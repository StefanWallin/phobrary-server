require "#{Rails.root}/lib/phobrary/scan.rb"
require "#{Rails.root}/lib/phobrary/cluster.rb"

namespace :phobrary do
  desc 'Clean photo library database'
  task :purge => :environment do
    Photo.destroy_all
    Shot.destroy_all
    Camera.destroy_all
    Folder.destroy_all
  end

  desc 'Run clustering algorithm'
  task :cluster => :environment do
    Phobrary::Commands::Cluster.jenks_moments
  end

  desc 'Scan photo library directories'
  task :scan => :environment do
    directory = File.join('..','library','source')
    index_directories(directory)
    index_photos(directory)
    output_newline_for_cli
  end

  def index_directories(directory)
    walk(directory, 0, 0) do |folderpath, depth, folder_id|
      localpath = folderpath.split(directory + '/')[1]
      Folder.find_or_create_by!(path: localpath, depth: depth, folder_id: folder_id )
      puts "#{depth} - #{folder_id} - #{localpath}"
    end
  end

  def walk(start, depth, folder_id, &folderprocessor)
    if depth.zero?
      folderprocessor.call(start, depth, folder_id)
      folder_id = "10#{folder_id}".to_i
      depth = depth += 1
    end
    Dir.foreach(start) do |x|
      path = File.join(start, x)
      if x == "." or x == ".."
        next
      elsif File.directory?(path)
        folderprocessor.call(path, depth, folder_id)
        nextlevel_folder_id = "#{folder_id}00".to_i
        walk(path, depth + 1, nextlevel_folder_id, &folderprocessor)
        folder_id = folder_id + 1
      end
    end
  end

  def index_photos(directory)
    Phobrary::Commands::Scan.each_image(directory) do |exif, index, count|
      printf("\rProcessing file %d of %d", index, count)
      folder = find_or_create_folder(exif)
      shot = find_or_create_shot(exif)
      photo = create_photo(exif, shot)
    end
  end

  def find_or_create_folder(exif)
    folders = File.dirname("root/#{localpath}").split(File.PATH_SEPARATOR)
    depth = 0
    folders.each do |folder|
      Folder.find_or_create_by!(
        path
      )
    end
    puts folderpath
  end


  def find_or_create_camera(exif)
    return nil if exif.nil?
    return nil if exif[:make].nil? && exif[:model].nil?
    return nil if exif[:make].empty? && exif[:model].empty?
    Camera.find_or_create_by!(make: exif[:make], model: exif[:model])
  end

  def find_or_create_shot(exif)
    camera = find_or_create_camera(exif)
    shot = Shot.find_or_create_by!(
      camera: camera,
      date: exif[:createdate],
      orientation: exif[:orientation],
      gpslatitude: exif[:gpslatitude],
      gpslongitude: exif[:gpslongitude],
      date_source: exif[:datesource]
    )
    raise "Shot was not created for photo: #{exif[:filepath]}" if shot.nil?
    shot
  end

  def create_photo(exif, shot)
    Photo.find_or_create_by!(
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

  def output_newline_for_cli
    # Progress indicator always eats newline. So to avoid screwing up the prompt
    # we need to output a newline at program end. This does that.
    puts
  end
end
