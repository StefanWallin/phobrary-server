# frozen_string_literal: true

class AuthAttempt < ApplicationRecord
  belongs_to :profile
  validates :secret, uniqueness: true
  before_create :ensure_one_valid_per_profile!
  before_validation :ensure_secret!

  def self.create_attempt(profile, count = 0)
    AuthAttempt.all.where(profile: profile, expired: false).update_all(expired: true)
    AuthAttempt.create!(profile: profile)
  rescue ActiveRecord::RecordInvalid => e
    return AuthAttempt.create_attempt(profile, count += 1) if count < 3
  end

  def ensure_secret!
    if secret.nil?
      self.secret = SecureRandom.alphanumeric(6).downcase
    end
  end

  def ensure_one_valid_per_profile!
    AuthAttempt.all.where(profile: profile, expired: false).update_all(expired: true)
  end

  def expired?
    expired || expires_at < DateTime.now
  end

  def expires_at
    (created_at + 10.minutes)
  end
end
