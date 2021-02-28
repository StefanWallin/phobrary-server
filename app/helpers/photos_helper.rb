# frozen_string_literal: true

module PhotosHelper
  def thumb_path(photo)
    filename = "#{photo.digest}.thumb.jpg"
    "/library/#{filename}"
  end
end
