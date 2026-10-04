#!/bin/bash
# Runs MulticastTest with an avahi daemon to talk to. If none is running,
# starts a private one: in a user and mount namespace with its own /run, a
# system D-Bus for it to register on, and avahi-daemon, both stopped when the
# test finishes. That needs no root, so it works in the RBE container.

set -euo pipefail

# The daemons live in sbin, which the test environment's PATH leaves out.
export PATH="${PATH}:/usr/sbin:/sbin"

if [[ "${1:-}" == "--in-namespace" ]]; then
  shift
  test_binary="$1"
  shift

  # A /run of our own for the D-Bus socket and avahi's pid file.
  mount -t tmpfs tmpfs /run
  mkdir -p /run/dbus

  # avahi-daemon chowns its runtime directory to the avahi user. Only root is
  # mapped into the namespace, so make avahi root here.
  scratch="${TEST_TMPDIR:-/tmp}"
  printf 'root:x:0:0::/root:/bin/sh\navahi:x:0:0::/run/avahi-daemon:/bin/false\n' \
    >"${scratch}/passwd"
  printf 'root:x:0:\navahi:x:0:\n' >"${scratch}/group"
  mount --bind "${scratch}/passwd" /etc/passwd
  mount --bind "${scratch}/group" /etc/group

  dbus_config="${scratch}/multicast_test_dbus.conf"
  cat >"${dbus_config}" <<'EOF'
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <type>system</type>
  <listen>unix:path=/run/dbus/system_bus_socket</listen>
  <auth>EXTERNAL</auth>
  <policy context="default">
    <allow user="*"/>
    <allow own="*"/>
    <allow send_destination="*"/>
    <allow receive_sender="*"/>
  </policy>
</busconfig>
EOF
  dbus_pid="$(dbus-daemon --config-file="${dbus_config}" --fork --print-pid)"

  avahi_log="${TEST_UNDECLARED_OUTPUTS_DIR:-${TEST_TMPDIR:-/tmp}}/avahi-daemon.log"
  avahi-daemon --no-drop-root --no-chroot --no-rlimits --debug \
    >"${avahi_log}" 2>&1 &
  avahi_pid=$!
  trap 'kill "${avahi_pid}" "${dbus_pid}" 2>/dev/null || true' EXIT

  status=0
  "${test_binary}" "$@" || status=$?
  if ((status != 0)); then
    echo "avahi-daemon log:" >&2
    cat "${avahi_log}" >&2
  fi
  exit "${status}"
fi

test_binary="$1"
shift

if avahi-daemon --check 2>/dev/null; then
  exec "${test_binary}" "$@"
fi

if ! command -v avahi-daemon >/dev/null; then
  echo "MulticastTest needs avahi-daemon, which isn't installed" >&2
  exit 1
fi

exec unshare --user --map-root-user --mount "$0" --in-namespace "${test_binary}" "$@"
