# frozen_string_literal: true
require 'fileutils'

class FileManager
  LIBRARY_DIR = File.join('..', 'library', 'target')
  def self.move_uploaded_file(uid, filename, username)
    # TODO, schedule this async and see if file lock on the info-file is released.
    uploaddir = File.join(LIBRARY_DIR, 'uploads', username)
    FileUtils.mkdir_p uploaddir
    current_path = File.join('.', 'public', 'tus', uid)
    target_path = File.join(uploaddir, uid)
    FileUtils.mv current_path, target_path
    info_path = File.join('.', 'public', 'tus', "#{uid}.info")
    puts "REMOVING: #{info_path} - #{File.exists?(info_path)}"
    puts exec('lsof')
    File.delete(info_path)
    puts "#{LIBRARY_DIR}"
    puts "#{uploaddir}"
    puts "#{current_path}"
  end
end
