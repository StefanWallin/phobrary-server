# frozen_string_literal: true
require 'active_support/core_ext/hash/keys'

def generate_default_server_config(path)
  File.open(path, 'w') do |file|
    contents = {
      server_uuid: SecureRandom.uuid,
    }
    file.write("# This is an automatically created file — Do not edit manually\n")
    file.write(contents.deep_stringify_keys.to_yaml)
    file.write("# This is an automatically created file — Do not edit manually\n")
  end
end

def load_server_config(path)
  config = YAML.load(File.read(path)).symbolize_keys
  Rails.application.config.server = config
end


path = Rails.root.join('config.yml')
generate_default_server_config(path) unless File.exist?(path)
load_server_config(path)
