# frozen_string_literal: true

class Folder < ApplicationRecord
  has_many :photos
end
