require 'listen'
require 'mini_exiftool'
require 'byebug'

module Phobrary::Commands
  class Scan
    DIRECTORY = File.join('..','library','source').freeze

    def self.perform(&block)
      nodes = Dir.glob(File.join(DIRECTORY, '**', '*')) # TODO: BAD PERF, CHUNK IT
      nodes.each_with_index do |nodepath, index|
        localpath = nodepath.split(DIRECTORY + '/')[1]
        next unless nodepath =~ /\A.*\.jp(e)?g\z/i # Only include jpgs
        block.call(self.extract_exif_data(nodepath, localpath), index + 1, nodes.length)
      end
    end

    def self.extract_exif_data(filepath, localpath)
      photo = MiniExiftool.new(filepath)
      {
        filepath: localpath,
        filetype: photo.filetype,
        modifydate: photo.modifydate,
        createdate: photo.createdate,
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

    def self.digest_file(filepath)
      Digest::MD5.file(filepath).hexdigest
    end

    def self.listen(&block)
      listener = Listen.to(DIRECTORY) do |modified, added, removed|
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
