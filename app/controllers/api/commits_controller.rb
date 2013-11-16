module Api
  class CommitsController < ApplicationController
    respond_to :json

    def index
      respond_with Commit.includes(:tags).all, include: :tags
    end

    def tag_counts
      tag_counts = Tag.count_text()

      series = []
      i = 0
      series_count = tag_counts.length
      tag_counts.each do |tag, count|
        data = []
        (1..i).each { |index| data << {x: index, y: 0} }
        data << { x: i, y: count }
        ((i+1)..(series_count-1) ).each { |index| data << {x: index, y: 0} }

        series << { name: tag, data: data }

        i += 1
      end

      respond_with series #Tag.count_text()
    end

    def counts_by_day_as_rickshaw
      result = []
      i = 0
      Tag.counts_by_day_as_rickshaw.each do |series, data|
        result << { name: series, data: data }
        i += 1
      end

      respond_with result
    end
  end
end