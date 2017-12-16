require "#{Rails.root}/lib/phobrary/scan.rb"

namespace :phobrary do
  desc 'Scan photo library directories'
  task :purge => :environment do
    Photo.destroy_all
    Shot.destroy_all
    Camera.destroy_all
  end

  task :scan => :environment do
    Phobrary::Commands::Scan.perform do |exif, index, count|
      printf("\rProcessing file %d of %d", index, count)
      shot = find_or_create_shot(exif)
      photo = create_photo(exif, shot)
    end
    puts #generates newline in cli after progress indicator
  end

  def find_or_create_camera(exif)
    return nil if exif[:make].empty? && exif[:model].empty?
    Camera.find_or_create_by(make: exif[:make], model: exif[:model])
  end

  def find_or_create_shot(exif)
    raise "File missing create date in exif data: #{exif[:filepath]}" unless exif[:createdate]
    camera = find_or_create_camera(exif)
    shot = Shot.find_or_create_by(
      camera: camera,
      date: exif[:createdate],
      orientation: exif[:orientation],
      gpslatitude: exif[:gpslatitude],
      gpslongitude: exif[:gpslongitude]
    )
    raise "Shot was not created for photo: #{exif[:filepath]}" if shot.nil?
    shot
  end

  def create_photo(exif, shot)
    Photo.find_or_create_by(
      shot: shot,
      digest: exif[:digest],
      original_filepath: exif[:filepath],
      current_filepath: exif[:filepath],
      filetype: exif[:filetype],
      modifydate: exif[:modifydate],
      imagewidth: exif[:imagewidth],
      imageheight: exif[:imageheight]
    )
  end
end
