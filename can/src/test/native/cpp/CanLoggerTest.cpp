// Copyright (c) FIRST and other WPILib contributors.
// Open Source Software; you can modify and/or share it under the terms of
// the WPILib BSD license file in the root directory of this project.

#include "wpi/can/CanLogger.hpp"

#include <linux/can.h>
#include <net/if.h>
#include <sys/socket.h>
#include <unistd.h>

#include <cstring>
#include <memory>
#include <stdexcept>
#include <string>
#include <string_view>
#include <utility>

#include <catch2/catch_test_macros.hpp>

#include "aos/events/simulated_event_loop.h"

namespace wpi::can {
namespace {

class CanLoggerTest {
 public:
  CanLoggerTest()
      : config_{aos::configuration::ReadConfig("can/aos_config.json")},
        factory_{&config_.message()} {
    int fds[2];
    REQUIRE(socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, fds) == 0);
    logger_fd_ = aos::ScopedFD{fds[0]};
    test_fd_ = aos::ScopedFD{fds[1]};

    event_loop_ = factory_.MakeEventLoop(
        "test_node", aos::configuration::GetNode(&config_.message(), "robot"));
    fetcher_ = event_loop_->MakeFetcher<CanFrame>("/can");
  }

 protected:
  aos::FlatbufferDetachedBuffer<aos::Configuration> config_;
  aos::SimulatedEventLoopFactory factory_;
  std::unique_ptr<aos::EventLoop> event_loop_;
  aos::ScopedFD logger_fd_;
  aos::ScopedFD test_fd_;
  aos::Fetcher<CanFrame> fetcher_;
};

}  // namespace

TEST_CASE_METHOD(CanLoggerTest, "CanLogger publishes a frame it read",
                 "[CanLogger]") {
  // SimulatedEventLoop has no epoll to wake on, so poll instead.
  CanLogger logger{event_loop_.get(), std::move(logger_fd_), "/can",
                   /*poll=*/true};

  canfd_frame frame;
  std::memset(&frame, 0, sizeof(frame));
  frame.can_id = 0x123;
  frame.len = 8;
  std::memcpy(frame.data, "testdata", 8);
  REQUIRE(write(test_fd_.get(), &frame, sizeof(frame)) ==
          static_cast<ssize_t>(sizeof(frame)));

  // Two periods, so the poll that reads the frame is not racing the write.
  factory_.RunFor(CanLogger::kPollPeriod * 2);

  REQUIRE(fetcher_.Fetch());
  REQUIRE(fetcher_->can_id() == 0x123u);
  REQUIRE(fetcher_->flags() == 0u);
  REQUIRE(fetcher_->data() != nullptr);
  REQUIRE(fetcher_->data()->size() == 8u);
  REQUIRE(std::string_view(
              reinterpret_cast<const char*>(fetcher_->data()->data()), 8) ==
          "testdata");
}

TEST_CASE_METHOD(CanLoggerTest,
                 "CanLogger only wakes for each frame on a ShmEventLoop",
                 "[CanLogger]") {
  REQUIRE_THROWS_AS(CanLogger(event_loop_.get(), std::move(logger_fd_), "/can",
                              /*poll=*/false),
                    std::invalid_argument);
}

TEST_CASE_METHOD(CanLoggerTest, "CanLogger rejects a too long interface name",
                 "[CanLogger]") {
  REQUIRE_THROWS_AS(CanLogger(event_loop_.get(), "/can",
                              std::string(IFNAMSIZ, 'x'), /*poll=*/true),
                    std::invalid_argument);
}

}  // namespace wpi::can
