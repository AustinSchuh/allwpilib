/*----------------------------------------------------------------------------*/
/* Copyright (c) FIRST 2008-2016. All Rights Reserved.                        */
/* Open Source Software - may be modified and shared by FRC teams. The code   */
/* must be accompanied by the FIRST BSD license file in the root directory of */
/* the project.                                                               */
/*----------------------------------------------------------------------------*/

#pragma once

#include <memory>
#include <sstream>

#include "MotorSafety.h"
#include "MotorSafetyHelper.h"
#include "PWM.h"

namespace frc {

/**
 * A safe version of the PWM class.
 * It is safe because it implements the MotorSafety interface that provides
 * timeouts in the event that the motor value is not updated before the
 * expiration time. This delegates the actual work to a MotorSafetyHelper
 * object that is used for all objects that implement MotorSafety.
 */
class SafePWM : public PWM, public MotorSafety {
 public:
  explicit SafePWM(int channel);
  virtual ~SafePWM() = default;

  void SetExpiration(double timeout);
  double GetExpiration() const;
  bool IsAlive() const;
  void StopMotor();
  bool IsSafetyEnabled() const;
  void SetSafetyEnabled(bool enabled);
  void GetDescription(std::ostringstream& desc) const;

  virtual void SetSpeed(double speed);

 private:
  std::unique_ptr<MotorSafetyHelper> m_safetyHelper;
};

}  // namespace frc
