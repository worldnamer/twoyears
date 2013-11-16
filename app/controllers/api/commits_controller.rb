module Api
  class CommitsController < ApplicationController
    respond_to :json

    COLORS = ["#80ED12", "#A5D604", "#C7B601", "#E39209", "#F66C1C", "#FE4838", "#FB295B", "#ED1180", "#D504A6", "#B601C8", "#910AE3", "#6B1DF6", "#4739FE", "#285BFB", "#1181ED", "#03A6D5", "#01C8B5", "#0AE491", "#1DF66B", "#3AFE47", "#5CFB28", "#82EC10", "#A7D403", "#C9B401", "#E4900A", "#F76A1E", "#FE463A", "#FB275D", "#EC1082", "#D403A8", "#B401CA", "#8F0AE5"]

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
      result = []
      i = 0
      Tag.counts_by_day_as_rickshaw.each do |series, data|
        result << { name: series, data: data, color: COLORS[i]}
        i += 1
      end

      respond_with result
    end
  end
end