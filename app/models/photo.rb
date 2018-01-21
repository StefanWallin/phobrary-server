class Photo < ApplicationRecord
  belongs_to :shot
  belongs_to :folder
end
