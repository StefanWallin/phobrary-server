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
    source_library_directory = File.join('..','library','source')
    target_library_directory = File.join('..','library','target')
    index_directories(source_library_directory)
    index_photos(source_library_directory, target_library_directory)
  end

  def index_directories(directory)
    walk(directory, 0, 0) do |folderpath, depth, folder_id|
      localpath = folderpath.split(directory + '/')[1]
      Folder.find_or_create_by!(path: localpath, depth: depth, folder_id: folder_id )
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

  def index_photos(source_dir, target_dir)
    Phobrary::Commands::Scan.each_image(source_dir) do |exif, index, count|
      printf("\rProcessing file %d of %d - folder", index, count)
      folder = find_or_create_folder(exif)
      printf("\rProcessing file %d of %d - duplicates", index, count)
      shot = find_or_create_shot(exif)
      printf("\rProcessing file %d of %d - exif", index, count)
      photo = create_photo(exif, shot, folder)
      printf("\rProcessing file %d of %d - thumbnail ", index, count)
      generate_thumb_nail(source_dir, target_dir, photo)
    end
    output_newline_for_cli
  end

  def generate_thumb_nail(source_dir, target_dir, photo)
    path = photo[:current_filepath]
    thumb_path = thumbnail_path(File.join(target_dir, path))
    return if File.exist? thumb_path
    create_nested_folder(File.dirname(thumb_path))
    original_path = File.join(source_dir, path)
    original = MiniMagick::Image.open original_path
    original.resize '200x200'
    original.write thumb_path
  end

  def create_nested_folder(dirname)
    folders = dirname.split(File::SEPARATOR)
    path = folders.shift
    Dir.mkdir(path) if valid_path?(path)
    folders.each do |folder|
      path = File.join(path, folder)
      Dir.mkdir(path) if valid_path?(path)
    end
  end

  def valid_path?(path)
    !(path == '..' || path == '.' || path == '' || File.directory?(path))
  end

  def thumbnail_path(path)
    URI.escape path.gsub(/\.jp(e)?g/i, '.thumb.jpg')
  end

  def find_or_create_folder(exif)
    pathname = File.join('root',exif[:filepath])
    folder = nil
    folders = File.dirname(pathname).split(File::SEPARATOR)
    folders.each_with_index do |folder, index|
      folder = Folder.find_or_create_by!(
        path: folder,
        depth: index,
      )
    end
    folder
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

  def create_photo(exif, shot, folder)
    # puts "Folder linking not yet implemented"
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
