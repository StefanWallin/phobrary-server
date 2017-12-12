require 'listen'
require 'mini_exiftool'
require 'byebug'

module Phobrary::Commands
  class Scan
    DIRECTORY = File.join('..','library','source').freeze

    def self.perform(&block)
      files = Dir.glob(File.join(DIRECTORY, '**', '*')) # TODO: BAD PERF
      files.each do |filename|
        localname = filename.split(DIRECTORY + '/')[1]
        next unless filename =~ /\A.*\.jpg\z/i
        photo = MiniExiftool.new filename
        block.call(
          filename: localname,
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
          digest: self.digest_file(filename)
        )


      end
    end

    def self.digest_file(filepath)
      Digest::MD5.file(filepath).hexdigest
    end

    def self.listen
      listener = Listen.to(DIRECTORY) do |modified, added, removed|
        puts "modified absolute path: #{modified}"
        puts "added absolute path: #{added}"
        puts "removed absolute path: #{removed}"
      end
      listener.start # not blocking
      sleep
    end
  end
end
