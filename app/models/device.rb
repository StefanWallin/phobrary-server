# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :profile, optional: true
  has_many :sessions, dependent: :destroy
  before_validation :ensure_secret!

  def self.find_and_update(id: nil, name: nil, app_version: nil)
    device = ActiveRecord::Base.transaction do
      device = Device.find_or_create_by(id: id)
      device.name = name
      # device.app_version = app_version # TODO: Store last seen app version on device
      device.touch
      device
    end
    device
  end

  def ensure_secret!
    if secret.nil?
      self.secret = ROTP::Base32.random
    end
  end
end
