class Shot < ApplicationRecord
  has_many :photos
  belongs_to :camera, optional: true
end
