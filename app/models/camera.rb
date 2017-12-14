class Camera < ApplicationRecord
  has_many :photos
  has_many :shots
end
