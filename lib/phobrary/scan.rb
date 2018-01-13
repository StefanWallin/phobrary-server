require 'listen'
require 'mini_exiftool'
require 'byebug'

module Phobrary::Commands
  class Scan
    def self.each_image(directory, &block)
      nodes = Dir.glob(File.join(directory, '**', '*')) # TODO: BAD PERF, CHUNK IT
      nodes.each_with_index do |nodepath, index|
        localpath = nodepath.split(directory + '/')[1]
        next unless nodepath =~ /\A.*\.jp(e)?g\z/i # Only include jpgs
        block.call(self.extract_exif_data(nodepath, localpath), index + 1, nodes.length)
      end
    end

    def self.extract_exif_data(filepath, localpath)
      photo = MiniExiftool.new(filepath)
      date = self.extract_dates(photo, filepath)
      {
        fullpath: filepath,
        filepath: localpath,
        filetype: photo.filetype,
        modifydate: date[:modifydate],
        createdate: date[:createdate],
        datesource: date[:datesource],
        make: photo.make,
        model: photo.model,
        orientation: photo.orientation,
        imagewidth: photo.imagewidth,
        imageheight: photo.imageheight,
        gpslatitude: photo.gpslatitude,
        gpslongitude: photo.gpslongitude,
        digest: self.digest_file(filepath)
      }
    end

    def self.extract_dates(exif, filepath)
      source = 'exif'
      ctime = exif[:createdate]
      mtime = exif[:modifydate]
      unless ctime
        Rails.logger.warn "File missing create date in exif data: #{filepath}"
        source = 'filesystem'
        ctime = File.ctime(filepath)
        mtime = File.mtime(filepath)
      end
      {
        createdate: ctime,
        modifydate: mtime,
        datesource: source
      }
    end

    def self.digest_file(filepath)
      Digest::MD5.file(filepath).hexdigest
    end

    def self.listen(directory, &block)
      listener = Listen.to(directory) do |modified, added, removed|
        puts "modified absolute path: #{modified}"
        puts "added absolute path: #{added}"
        puts "removed absolute path: #{removed}"
        puts "NOT YET IMPLEMENTED"
      end
      listener.start # not blocking
      sleep
    end
  end
end
