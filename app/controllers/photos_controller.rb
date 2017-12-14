class PhotosController < ApplicationController

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end
end
