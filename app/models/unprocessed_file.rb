class UnprocessedFile < ApplicationRecord
  has_one_attached :raw_file
end
