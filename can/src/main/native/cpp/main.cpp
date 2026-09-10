// Copyright (c) FIRST and other WPILib contributors.
// Open Source Software; you can modify and/or share it under the terms of
// the WPILib BSD license file in the root directory of this project.

#include <cstdio>
#include <exception>
#include <optional>
#include <string_view>
#include <vector>

#include "aos/configuration.h"
#include "aos/events/shm_event_loop.h"
#include "aos/init.h"
#include "aos/realtime.h"
#include "wpi/can/CanLogger.hpp"
#include "wpi/util/StringExtras.hpp"
#include "wpi/util/print.hpp"

int main(int argc, char** argv) {
  bool poll = false;
  int priority = 10;
  std::optional<int> affinity;

  // Take our options out of argv. Everything else is AOS's, and InitGoogle
  // rejects flags it does not know.
  std::vector<char*> aos_args{argv[0]};
  for (int i = 1; i < argc; ++i) {
    std::string_view arg{argv[i]};
    if (arg == "--poll") {
      poll = true;
    } else if (arg == "--priority" || arg == "--affinity") {
      std::optional<int> value;
      if (i + 1 < argc) {
        value = wpi::util::parse_integer<int>(argv[++i], 10);
      }
      if (!value) {
        wpi::util::print(stderr, "{} needs an integer\n", arg);
        return 1;
      }
      if (arg == "--priority") {
        priority = *value;
      } else {
        affinity = *value;
      }
    } else {
      aos_args.push_back(argv[i]);
    }
  }

  int aos_argc = static_cast<int>(aos_args.size());
  char** aos_argv = aos_args.data();
  aos::InitGoogle(&aos_argc, &aos_argv);
  if (aos_argc > 2) {
    wpi::util::print(
        stderr,
        "usage: {} [--poll] [--priority N] [--affinity CPU] [interface]\n",
        argv[0]);
    return 1;
  }
  std::string_view interface_name = aos_argc == 2 ? aos_argv[1] : "can0";

  aos::FlatbufferDetachedBuffer<aos::Configuration> config =
      aos::configuration::ReadConfig("aos_config.json");

  aos::ShmEventLoop event_loop(&config.message());
  if (!poll) {
    event_loop.SetRuntimeRealtimePriority(priority);
  }
  if (affinity) {
    event_loop.SetRuntimeAffinity(aos::MakeCpusetFromCpus({*affinity}));
  }

  try {
    wpi::can::CanLogger can_logger{&event_loop, "/can", interface_name, poll};
    event_loop.Run();
  } catch (const std::exception& e) {
    wpi::util::print(stderr, "{}\n", e.what());
    return 1;
  }

  return 0;
}
