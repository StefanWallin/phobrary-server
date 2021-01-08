source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# rails
gem 'bootsnap'
gem 'dnssd'
gem 'jbuilder', '~> 2.9'
gem 'pg', '~> 1.1'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.1.1'
gem 'redis-rails'
gem 'sass-rails', '~> 6.0'
gem 'spawnling'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.0'
# gem 'rack-cors'

# App & Clustering
gem 'onedclusterer'
gem 'measurable'

# CLI
gem 'mini_exiftool_vendored'
gem 'mini_exiftool'
gem 'mini_magick'

# File Upload
gem 'carrierwave'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'rspec_junit_formatter', '0.4.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
