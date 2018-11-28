require File.expand_path("../scan.rb", __FILE__)

module Phobrary::Commands
  class Index
    class << self
      def index_directories(directory)
        walk(directory, 0, 0) do |folderpath, depth, folder_id|
          localpath = folderpath.split(directory + File::SEPARATOR)[1]
          next if localpath.present? && localpath[0] == '.'
          localpath = File.dirname('') if localpath.nil?
          Folder.find_or_create_by!(path: localpath, depth: depth, folder_id: folder_id )
        end
      end

      def index_photos(source_dir, target_dir)
        Phobrary::Commands::Scan.each_image(source_dir) do |exif, index, count|
          IndexingChannel.broadcast("Processing file #{index} of #{count}")
          printf("\r                                                                                             ")
          printf("\rProcessing file %d of %d - folder", index, count)
          folder = find_folder(exif)
          printf(' - duplicates', index, count)
          shot = find_or_create_shot(exif)
          printf(' - exif', index, count)
          photo = create_photo(exif, shot, folder)
          printf(' - thumbnail ', index, count)
          generate_thumb_nail(source_dir, target_dir, photo)
        end
        output_newline_for_cli
      end

      private

      def walk(start, depth, folder_id, &folderprocessor)
        if depth.zero?
          folderprocessor.call(start, depth, folder_id)
          folder_id = "100#{folder_id}".to_i
          depth = depth += 1
        end
        Dir.foreach(start) do |x|
          path = File.join(start, x)
          if x == "." or x == ".."
            next
          elsif File.directory?(path)
            folderprocessor.call(path, depth, folder_id)
            nextlevel_folder_id = "#{folder_id}000".to_i
            walk(path, depth + 1, nextlevel_folder_id, &folderprocessor)
            folder_id = folder_id + 1
          end
        end
      end


      def generate_thumb_nail(source_dir, target_dir, photo)
        path = photo[:current_filepath]
        thumb_path = thumbnail_path(target_dir, photo)
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

      def thumbnail_path(target_dir, photo)
        filename = "#{photo[:digest]}.thumb.jpg"
        File.join(target_dir, filename)
      end

      def find_folder(exif)
        pathname = exif[:filepath]
        result_folder = nil
        folders = File.dirname(pathname).split(File::SEPARATOR)
        folders.each_with_index do |folder, index|
          result_folder = Folder.find_by!(path: folder)
        end
        result_folder
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
        Photo.find_or_create_by!(
          shot: shot,
          digest: exif[:digest],
          original_filepath: exif[:filepath],
          current_filepath: exif[:filepath],
          filetype: exif[:filetype],
          createdate: exif[:createdate],
          modifydate: exif[:modifydate],
          imagewidth: exif[:imagewidth],
          imageheight: exif[:imageheight],
          folder_id: folder.id
        )
      end

      def output_newline_for_cli
        # Progress indicator always eats newline. So to avoid screwing up the prompt
        # we need to output a newline at program end. This does that.
        puts
      end
    end
  end
end
