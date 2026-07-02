#include "can/can_logger.h"

#include <sys/socket.h>
#include <unistd.h>

#include "gtest/gtest.h"
#include "absl/flags/flag.h"
#include "aos/events/simulated_event_loop.h"

ABSL_DECLARE_FLAG(bool, poll);

namespace frc::can_logger::testing {

class CanLoggerTest : public ::testing::Test {
 protected:
  CanLoggerTest()
      : config_(aos::configuration::ReadConfig("can/aos_config.json")),
        simulated_event_loop_factory_(&config_.message()) {
    // Set poll to true to allow SimulatedEventLoop to poll without epoll.
    absl::SetFlag(&FLAGS_poll, true);

    int fds[2];
    PCHECK(socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, fds) == 0);
    logger_fd_ = aos::ScopedFD(fds[0]);
    test_fd_ = aos::ScopedFD(fds[1]);

    const aos::Node *node =
        aos::configuration::GetNode(&config_.message(), "robot");
    event_loop_ = simulated_event_loop_factory_.MakeEventLoop("test_node", node);
    
    // Create fetcher to read logged CAN frames.
    can_frame_fetcher_ = event_loop_->MakeFetcher<CanFrame>("/can");
  }

  aos::FlatbufferDetachedBuffer<aos::Configuration> config_;
  aos::SimulatedEventLoopFactory simulated_event_loop_factory_;
  std::unique_ptr<aos::EventLoop> event_loop_;
  aos::ScopedFD logger_fd_;
  aos::ScopedFD test_fd_;
  aos::Fetcher<CanFrame> can_frame_fetcher_;
};

TEST_F(CanLoggerTest, PollAndPublishFrame) {
  // Construct the CanLogger.
  CanLogger can_logger(event_loop_.get(), std::move(logger_fd_), "/can");

  // Send a simulated CAN FD frame.
  struct canfd_frame frame;
  std::memset(&frame, 0, sizeof(frame));
  frame.can_id = 0x123;
  frame.flags = 0;
  frame.len = 8;
  std::memcpy(frame.data, "testdata", 8);

  PCHECK(write(test_fd_.get(), &frame, sizeof(frame)) == sizeof(frame));

  // Run the event loop for a couple periods to ensure CanLogger polls and reads.
  simulated_event_loop_factory_.RunFor(CanLogger::kPollPeriod * 2);

  // Fetch and check the output.
  ASSERT_TRUE(can_frame_fetcher_.Fetch());
  EXPECT_EQ(can_frame_fetcher_->can_id(), 0x123u);
  EXPECT_EQ(can_frame_fetcher_->flags(), 0u);
  ASSERT_NE(can_frame_fetcher_->data(), nullptr);
  EXPECT_EQ(can_frame_fetcher_->data()->size(), 8u);
  EXPECT_EQ(std::string_view(reinterpret_cast<const char*>(can_frame_fetcher_->data()->data()), 8), "testdata");
}

}  // namespace frc::can_logger::testing
