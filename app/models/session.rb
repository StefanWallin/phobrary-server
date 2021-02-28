# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :device
  validates :device_id, presence: true
  validates :access_token, presence: true

  def expired?
    expired || (active_at + 1.month) < DateTime.now
  end
end
