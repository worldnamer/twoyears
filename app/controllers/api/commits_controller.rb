require 'csv'

module Api
  class CommitsController < ApplicationController
    respond_to :json, :csv

    def index
      @commits = Commit.includes(:tags).order("committed_at DESC").all
      respond_to do |format|
        format.json do
          render json: @commits.to_json(include: {tags: {only: :text}}, except: [:id])
        end
        format.csv do 
          text = CSV.generate do |csv|
            csv << ["repository", "commit_hash", "committed_at", "message", "tags"]
            @commits.each do |commit|
              csv << [commit.repository, commit.commit_hash, commit.committed_at, commit.message, commit.tags.map(&:text).join(',')]
            end
          end

          render text: text
        end
      end
    end

    def counts_by_day_as_rickshaw
      result = []
      i = 0

      Tag.counts_by_day_as_rickshaw.each do |series, data|
        result << { name: series, data: data }
        i += 1
      end

      earliest_date = Commit.select("committed_at").order("committed_at asc").first.committed_at.to_date.to_time.to_i

      respond_with({ first_day: earliest_date, series: result })
    end

    def by_day
      earliest_date = Commit.select("committed_at").order("committed_at asc").first.committed_at.to_date.to_time.to_i

      respond_with({ first_day: earliest_date, data: Commit.by_day })
    end

    def by_week
      earliest_date = Commit.select("committed_at").order("committed_at asc").first.committed_at.to_date.to_time.to_i

      respond_with({ first_day: earliest_date, data: Commit.by_week })
    end
  end
end