class Shot < ApplicationRecord
  has_many :photos
  belongs_to :camera
end
