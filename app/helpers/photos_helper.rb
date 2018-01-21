module PhotosHelper

  def thumb_path(current_filepath)
    thumb_path = current_filepath.gsub(/\.jpg\z/i,'.thumb.jpg')
    "/library/#{thumb_path}"
  end
end
