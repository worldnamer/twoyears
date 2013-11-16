module Api
  class CommitsController < ApplicationController
    respond_to :json

    COLORS = ["#CC0088", "#990088", "#991199", "#992299", "#993399", "#994499", "#995599", "#996699", "#997799", "#998899", "#999999", "#99AA99", "#99BB99", "#99CC99", "#99DD99", "#99EE99", "#99FF99", "#00FF99", "#00EE99", "#00DD99"]

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

        series << { name: tag, data: data, color: COLORS[i]}

        i += 1
      end

      respond_with series #Tag.count_text()
    end

    def counts_by_day_as_rickshaw
      respond_with Tag.counts_by_day_as_rickshaw
    end
  end
end