[![StefanWallin/phobrary-server Build Status](https://circleci.com/gh/StefanWallin/phobrary-server.svg?style=svg)](https://circleci.com/gh/StefanWallin/phobrary-server)
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=StefanWallin/phobrary-server)](https://dependabot.com)


# Phobrary
My own Photo Library

## Why?

The intention of this is to have a photo library machine that goes through multiple messy folders of images and organizes them and write the organization back to the folder structure and the images exif-data.

## Features
- Image deduplication (currently only identifies via hash)
- Thumbnail generation

## Intended features
- Write modified exif-data back to files
- Re-organization of images into folder structures based on user sorting

... and more, you can [follow the status on the project pane](https://github.com/StefanWallin/phobrary/projects/1)

# Usage
This is mainly a rails app with a rake task. If you need help to get started, see the heading **[Get started](https://github.com/StefanWallin/phobrary#get-started)** below.

## Indexing your library:
```
bundle exec phobrary:scan
```

## Start your server
```
bundle exec rails server
```
Then point your browser to [http://localhost:3000](http://localhost:3000) and enjoy!.
# Get started
Clone this repo to your computer using your terminal emulator like so:
```
  cd ; mkdir -p `gitstuff`; cd gitstuff
  git clone https://github.com/StefanWallin/phobrary.git
  cd phobrary
```

## Ruby version
Install ruby version listed in the file `.ruby-version`. I recommend using the `rbenv` tool for that. After installing `rbenv` and `rbenv-build` it can be done like this:
```
rbenv install `cat .ruby-version`
```

## Install dependencies
To get this app running you need to install bundler to manage your dependencies. You can do this from your terminal with this command:
```
  gem install bundler
```

Then, run this command in your terminal so bundler can install the needed dependency libraries:
`bundle install`

## Database setup
This software needs a postgresql database setup. You can search the internet for how to do this. If you are on a Mac, I recommend using homebrew to install postgres. Once your database is installed you need to have a postgres user setup, that can be done like so:
```
sudo -u postgres psql
CREATE USER phobrary WITH ENCRYPTED PASSWORD 'phobrary123';
GRANT ALL PRIVILEGES ON DATABASE phobrary_development TO phobrary;
GRANT ALL PRIVILEGES ON DATABASE phobrary_test TO phobrary;
```
Then hit `ctrl+d` to exit the psql prompt

## Database initialization
```
bundle exec rails db:setup
```

## How to run the test suite
```
bundle exec rspec
```
