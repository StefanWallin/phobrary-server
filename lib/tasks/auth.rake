# frozen_string_literal: true

namespace :auth do
  desc 'Create auth'
  task :create, [:name] => :environment do |_task, args|
    name = args[:name]
    if name.blank?
      STDERR.puts("Missing name argument\n");
      exit 1 unless Rails.env == 'test'
    end
    profile = Profile.find_or_create_by(name: name)
    attempt = AuthAttempt.create_attempt(profile)
    [
      "Hi #{name},",
      "your auth code is: #{attempt.secret}",
      "and it expires: #{attempt.expires_at.localtime}"
    ].each { |m| puts m }
    puts `echo \"com.phobrary.uploader_app://auth/v1/#{attempt.secret}\"|npx qrcode-terminal`
  end
end
