require 'rails_helper'
require_relative '../../app/lib/phobrary/index.rb'

RSpec.describe Phobrary::Commands::Index do
  after(:each) do
    clean_target_directory!
  end

  describe '.index_directories' do
    context 'when indexing empty_folders_test' do
      before do
        expect(IndexingChannel).not_to receive(:broadcast)
        index_folder 'empty_folders_test'
      end

      it 'indexes empty folders' do
        expect(Folder.count).to eq 2
      end

      it 'does index the root folder' do
        expect(Folder.first.path).to eq '.'
      end

      it 'does not index hidden folders' do
        expect(Folder.where(path: '.hidden').count).to eq 0
      end
    end
  end

  describe '.index_photos' do
    context 'when indexing empty_folders_test' do
      before do
        index_photos 'empty_folders_test'
      end

      it 'does not index hidden files' do
        expect(Photo.count).to eq 0
        expect(Shot.count).to eq 0
        expect(Camera.count).to eq 0
      end
    end

    context 'when indexing disallowed_files' do
      before do
        index_photos 'disallowed_files'
      end

      it 'does not index text files' do
        expect(Photo.where('original_filepath LIKE ?', '%.txt').count).to eq 0
      end

      it 'does not index gif files' do
        expect(Photo.where('original_filepath LIKE ?', '%.gif').count).to eq 0
      end
    end

    context 'when indexing hash_duplicate_files' do
      before do
        folder = 'hash_duplicate_files'
        index_folder folder
        index_photos folder
      end

      xit 'does index all the duplicate photos' do
        expect(Photo.count).to eq 2
      end

      xit 'only create one shot with one thumbnail based on content hash' do
        expect(Shot.count).to eq 1
        expect(Dir.glob(File.join(target_directory, '*')).length).to eq 1
      end

      xit 'creates a camera when indexing' do
        expect(Camera.count).to eq 1
      end
    end
  end
end


def index_photos(folder_name)
  source_directory = test_folder_path folder_name
  Phobrary::Commands::Index.index_photos source_directory, target_directory
end

def index_folder(folder_name)
  directory = test_folder_path folder_name
  Phobrary::Commands::Index.index_directories directory
end

def test_folder_path(folder_name)
  File.join('spec', 'fixtures', folder_name)
end

def target_directory
  File.join('tmp', 'spec_target_output')
end

def clean_target_directory!
  FileUtils.rm_rf(target_directory, secure: true)
end
