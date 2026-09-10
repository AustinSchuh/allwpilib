// Copyright (c) FIRST and other WPILib contributors.
// Open Source Software; you can modify and/or share it under the terms of
// the WPILib BSD license file in the root directory of this project.

#include "wpi/can/CanLogger.hpp"

#include <linux/can.h>
#include <linux/can/raw.h>
#include <linux/sockios.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <unistd.h>

#include <algorithm>
#include <cerrno>
#include <cstdio>
#include <cstring>
#include <format>
#include <stdexcept>
#include <utility>

#include "aos/events/shm_event_loop.h"
#include "aos/realtime.h"
#include "wpi/util/print.hpp"

namespace {

// Reports a problem on the event loop thread, which carries on afterwards.
// Printing allocates, and AOS aborts on allocation in a realtime section.
template <typename... T>
void PrintError(std::format_string<T...> format, T&&... args) {
  aos::ScopedNotRealtime not_realtime;
  wpi::util::print(stderr, format, std::forward<T>(args)...);
}

aos::ScopedFD CreateSocket(std::string_view interface_name) {
  if (interface_name.size() >= IFNAMSIZ) {
    throw std::invalid_argument(
        std::format("CAN interface name '{}' is longer than {} characters",
                    interface_name, IFNAMSIZ - 1));
  }

  aos::ScopedFD fd(socket(PF_CAN, SOCK_RAW | SOCK_NONBLOCK, CAN_RAW));
  if (fd.get() < 0) {
    throw std::runtime_error(
        std::format("could not open a CAN socket: {}", std::strerror(errno)));
  }

  struct ifreq ifr;
  std::memset(&ifr, 0, sizeof(ifr));
  std::copy(interface_name.begin(), interface_name.end(), ifr.ifr_name);
  if (ioctl(fd.get(), SIOCGIFINDEX, &ifr) != 0) {
    throw std::runtime_error(
        std::format("could not find CAN interface '{}': {}", interface_name,
                    std::strerror(errno)));
  }

  int enable_canfd = true;
  if (setsockopt(fd.get(), SOL_CAN_RAW, CAN_RAW_FD_FRAMES, &enable_canfd,
                 sizeof(enable_canfd)) != 0) {
    throw std::runtime_error(std::format("could not enable CAN FD on '{}': {}",
                                         interface_name, std::strerror(errno)));
  }

  struct sockaddr_can addr;
  std::memset(&addr, 0, sizeof(addr));
  addr.can_family = AF_CAN;
  addr.can_ifindex = ifr.ifr_ifindex;
  if (bind(fd.get(), reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) != 0) {
    throw std::runtime_error(
        std::format("could not bind to CAN interface '{}': {}", interface_name,
                    std::strerror(errno)));
  }

  return fd;
}

}  // namespace

namespace wpi::can {

CanLogger::CanLogger(aos::EventLoop* event_loop, std::string_view channel_name,
                     std::string_view interface_name, bool poll)
    : CanLogger(event_loop, CreateSocket(interface_name), channel_name, poll) {}

CanLogger::CanLogger(aos::EventLoop* event_loop, aos::ScopedFD fd,
                     std::string_view channel_name, bool poll)
    : event_loop_(event_loop),
      fd_(std::move(fd)),
      poll_(poll),
      frames_sender_(event_loop_->MakeSender<CanFrame>(channel_name)) {
  if (poll_) {
    aos::TimerHandler* timer_handler =
        event_loop_->AddTimer([this]() { Poll(); });
    timer_handler->set_name("CAN logging Loop");
    timer_handler->Schedule(event_loop_->monotonic_now(), kPollPeriod);
  } else {
    aos::ShmEventLoop* shm_event_loop =
        dynamic_cast<aos::ShmEventLoop*>(event_loop_);
    if (shm_event_loop == nullptr) {
      throw std::invalid_argument(
          "CanLogger can only wake for each frame on an aos::ShmEventLoop; "
          "poll on any other event loop");
    }
    shm_event_loop->aio()->OnReadable(fd_.get(), [this]() { Poll(); });
  }
}

CanLogger::~CanLogger() {
  if (!poll_ && fd_.get() >= 0) {
    aos::ShmEventLoop* shm_event_loop =
        dynamic_cast<aos::ShmEventLoop*>(event_loop_);
    if (shm_event_loop != nullptr) {
      shm_event_loop->aio()->DeleteFd(fd_.get());
    }
  }
}

void CanLogger::Poll() {
  while (ReadFrame()) {
  }
}

bool CanLogger::ReadFrame() {
  struct canfd_frame frame;
  ssize_t bytes_read = read(fd_.get(), &frame, sizeof(frame));
  if (bytes_read <= 0) {
    if (bytes_read < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
      PrintError("CanLogger: could not read the CAN socket: {}\n",
                 std::strerror(errno));
    }
    return false;
  }
  if (bytes_read != static_cast<ssize_t>(CAN_MTU) &&
      bytes_read != static_cast<ssize_t>(CANFD_MTU)) {
    PrintError("CanLogger: dropping a {} byte CAN frame\n", bytes_read);
    return true;
  }

  aos::Sender<CanFrame>::Builder builder = frames_sender_.MakeBuilder();

  auto frame_data = builder.fbb()->CreateVector<uint8_t>(frame.data, frame.len);

  CanFrame::Builder can_frame_builder = builder.MakeBuilder<CanFrame>();
  can_frame_builder.add_can_id(frame.can_id);
  can_frame_builder.add_flags(frame.flags);
  can_frame_builder.add_data(frame_data);
  struct timeval tv;
  if (ioctl(fd_.get(), SIOCGSTAMP, &tv) == 0) {
    can_frame_builder.add_realtime_timestamp_ns(
        std::chrono::duration_cast<std::chrono::nanoseconds>(
            std::chrono::seconds(tv.tv_sec) +
            std::chrono::microseconds(tv.tv_usec))
            .count());
  }

  if (builder.Send(can_frame_builder.Finish()) != aos::RawSender::Error::kOk) {
    PrintError("CanLogger: could not send a CAN frame, dropping it\n");
  }

  return true;
}

}  // namespace wpi::can
