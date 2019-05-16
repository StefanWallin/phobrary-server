# frozen_string_literal: true

class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.json
  def index
    date_sorted_shots = Shot.all.order(:date)
    @n_photos = Photo.count
    @n_shots = Shot.count
    @n_cameras = Camera.count
    shot_photos = date_sorted_shots.map(&:photos)
    @photos_per_shot = date_sorted_shots.map { |s| { shot: s.id, photos: s.photos.length } }.sort { |x, y| y[:photos] <=> x[:photos] }.take 5
    @photos = shot_photos.flatten
  end
end
