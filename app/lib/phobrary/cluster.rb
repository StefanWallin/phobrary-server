# frozen_string_literal: true

require 'onedclusterer'

module Phobrary::Commands
  class Cluster
    def self.jenks_moments
      dates = Shot.all.order(:date).pluck(:date).map(&:to_i)
      dates.each do |d|
        puts d
      end
      jenks = OnedClusterer::Jenks.new(dates, 7)
      p '============'
      p jenks.clusters
      p '============'
      p jenks.bounds
      p '============'
      jenks.bounds.map do |b|
        puts DateTime.strptime(b.to_s, '%s').iso8601
      end
      p '============'
    end

    def self.cosine_distance
      photoIds = []
      creationDates = []
      folderIds = []
      Photo.eager_load(:folder, :shot).find_each do |photo|
        photoIds.push(photo.id)
        creationDates.push(photo.createdate.to_i)
        folderIds.push(photo.folder.folder_id)
      end
      photoIds.each_with_index do |id_a, index_a|
        photoIds.each_with_index do |id_b, index_b|
          next if index_a == index_b

          distance = Measurable.cosine_distance(
            [creationDates[index_a]],
            [creationDates[index_b]]
          )
          puts "#{id_a} #{id_b} #{distance} #{creationDates[index_a]} #{creationDates[index_b]} #{folderIds[index_a]} #{folderIds[index_b]}"
        end
      end
    end
  end
end
