# frozen_string_literal: true

class Profile < ApplicationRecord
  has_many :auth_attempts, dependent: :destroy
  has_many :devices, dependent: :destroy
end
