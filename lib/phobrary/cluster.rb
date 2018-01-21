require 'onedclusterer'

module Phobrary::Commands
  class Cluster
    def self.jenks_moments
      dates = Shot.all.order(:date).pluck(:date).map(&:to_i)
      dates.each do |d|
        puts d
      end
      jenks = OnedClusterer::Jenks.new(dates, 7)
      p "============"
      p jenks.clusters
      p "============"
      p jenks.bounds
      p "============"
      jenks.bounds.map do |b|
        puts DateTime.strptime(b.to_s, '%s').iso8601
      end
      p "============"

    end

    def self.cosine_distance
      photos = []
      Photo.eager_load(:folder, :shot).find_each do |photo|
        photos.push({
          photo_id: photo.id,
          shot: photo.shot.id,
          lat: photo.shot.gpslongitude,
          long: photo.shot.gpslatitude,
          create_date: photo.createdate.to_i,
          folder_index: photo.folder.folder_id
        })
      end
      pp photos
    end
  end
end
