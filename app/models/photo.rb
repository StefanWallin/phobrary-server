# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :shot
  belongs_to :folder
end
