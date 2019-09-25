class UnprocessedFile < ApplicationRecord
  mount_uploader :file, MediaFileUploader
end
