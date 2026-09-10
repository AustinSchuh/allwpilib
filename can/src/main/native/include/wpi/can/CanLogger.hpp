// Copyright (c) FIRST and other WPILib contributors.
// Open Source Software; you can modify and/or share it under the terms of
// the WPILib BSD license file in the root directory of this project.

#pragma once

#include <chrono>
#include <string_view>

#include "aos/events/event_loop.h"
#include "aos/scoped/scoped_fd.h"
#include "can/CanLogging_generated.h"

namespace wpi::can {

/**
 * Publishes every frame on a SocketCAN interface to an AOS channel, so it can
 * be recorded with AOS's logging infrastructure.
 */
class CanLogger {
 public:
  static constexpr std::chrono::milliseconds kPollPeriod =
      std::chrono::milliseconds(100);

  /**
   * Opens a SocketCAN interface and publishes every frame on it.
   *
   * @param event_loop The event loop to publish on. Must outlive this.
   * @param channel_name The channel to publish CanFrame messages on.
   * @param interface_name The SocketCAN interface to read, such as "can0".
   * @param poll If true, read the socket every kPollPeriod. If false, wake for
   *             each frame, which needs an aos::ShmEventLoop.
   * @throws std::invalid_argument if interface_name is too long, or if poll is
   *         false and event_loop is not an aos::ShmEventLoop.
   * @throws std::runtime_error if the interface cannot be opened.
   */
  explicit CanLogger(aos::EventLoop* event_loop,
                     std::string_view channel_name = "/can",
                     std::string_view interface_name = "can0",
                     bool poll = false);

  /**
   * Publishes every frame read from an already open socket.
   *
   * @param event_loop The event loop to publish on. Must outlive this.
   * @param fd The socket to read.
   * @param channel_name The channel to publish CanFrame messages on.
   * @param poll If true, read the socket every kPollPeriod. If false, wake for
   *             each frame, which needs an aos::ShmEventLoop.
   * @throws std::invalid_argument if poll is false and event_loop is not an
   *         aos::ShmEventLoop.
   */
  explicit CanLogger(aos::EventLoop* event_loop, aos::ScopedFD fd,
                     std::string_view channel_name = "/can", bool poll = false);

  CanLogger(const CanLogger&) = delete;
  CanLogger& operator=(const CanLogger&) = delete;

  ~CanLogger();

 private:
  void Poll();

  // Sends one frame from the socket. Returns false when there is nothing more
  // to read.
  bool ReadFrame();

  aos::EventLoop* event_loop_;
  aos::ScopedFD fd_;
  bool poll_;
  aos::Sender<CanFrame> frames_sender_;
};

}  // namespace wpi::can
