require "#{Rails.root}/lib/phobrary/scan.rb"

namespace :phobrary do
  desc 'Scan photo library directories'
  task :purge => :environment do
    Photo.destroy_all
  end

  task :scan => :environment do
    puts Photo.all.length
    duplicates = []
    Phobrary::Commands::Scan.perform do |data|
      photo = Photo.find_or_create_by(digest: data[:digest]) do |p|
        p.original_filename = data[:filename]
      end
      if photo.filename
        duplicates.push data[:filename]
        Rails.logger.debug("Found matching photo: #{data[:filename]}, #{photo.original_filename}")
      end
      photo.filename = data[:filename]
      photo.filetype = data[:filetype]
      photo.modifydate = data[:modifydate]
      photo.createdate = data[:createdate]
      photo.make = data[:make]
      photo.model = data[:model]
      photo.orientation = data[:orientation]
      photo.imagewidth = data[:imagewidth]
      photo.imageheight = data[:imageheight]
      photo.gpslatitude = data[:gpslatitude]
      photo.gpslongitude = data[:gpslongitude]
      photo.save!
    end
    puts duplicates.count
  end
end
