# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# rails & storage
gem 'bootsnap', '~> 1.7.2'
gem 'jbuilder', '~> 2.9'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.2.1'
gem 'rails', '~> 6.1.3'
gem 'redis-rails'

# Frontend
gem 'sass-rails', '~> 6.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 6.0.0-beta.6'
# gem 'rack-cors'

# Discoverability over MDNS
gem 'dnssd', '~> 3.0.1'
gem 'spawnling', '~> 2.1.6'

# App & Clustering
gem 'measurable', '~> 0.0.9'
gem 'onedclusterer', '~> 0.2.0'

# CLI
gem 'mini_exiftool', '~> 2.10.0'
gem 'mini_exiftool_vendored', '9.2.7.v1'
gem 'mini_magick', '~> 4.11.0'

# Auth via TOTP (& QR)
gem 'rqrcode', '~> 1.2.0'
gem 'rotp'

# File Upload
gem 'carrierwave'

group :development, :test do
  gem 'byebug', '~> 11.1.3'
  gem 'rubocop-performance', '~> 1.9.2'
  gem 'rubocop-rails', '~> 2.9.1'
  gem 'rubocop-rspec', '~> 2.2.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.5'
  gem 'spring', '~> 2.1.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails', '~> 4.0.2'
  gem 'rspec_junit_formatter', '0.4.1'
  gem 'webmock', '~> 3.13'
end
