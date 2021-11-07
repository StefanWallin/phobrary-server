# frozen_string_literal: true

class Authentication
  def self.create!(auth_attempt, device)
    raise Unauthorized, 'invalid one time code' if auth_attempt.nil? || auth_attempt.expired?
    return session_for_device(device, auth_attempt) if device.persisted? && device.profile.present?

    device.profile = auth_attempt.profile
    device.save!
    session_for_device(device, auth_attempt)
  end

  private

  def self.session_for_device(device, auth_attempt)
    session = Session.create!(
      device: device,
      access_token: SecureRandom.urlsafe_base64(64)
    )
    auth_attempt.expired = true
    auth_attempt.save!
    session
  end

  def self.authorized?(session)
    return false if session.nil?
    return false if session.expired?

    session.update_columns(
      active_at: Time.current
    )
    true
  end

  def self.authenticated?(totp, device)
    @verified ||= self.verify_otp(totp, device)
  end

  def self.verify_otp(totp, device)
    rotp = ROTP::TOTP.new(device.secret)
    rotp.verify(totp, drift_behind: 15)
  end

  class Unauthenticated < StandardError; end
  class Unauthorized < StandardError; end
end
