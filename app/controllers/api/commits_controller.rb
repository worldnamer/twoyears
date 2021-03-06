require 'csv'

module Api
  class CommitsController < ApplicationController
    respond_to :json, :csv

    def index
      @commits = Commit.where(user_id: current_user.id).includes(:tags).order("committed_at DESC").all
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

      earliest_date = Commit.where(user_id: current_user.id).earliest_time.to_date.to_time.to_i

      respond_with({ first_day: earliest_date, series: result })
    end

    def by_period
      earliest_date = Commit.where(user_id: current_user.id).earliest_time.to_date.to_time.to_i

      if params[:period] == "week"
        data = Commit.by_week
      elsif params[:period] == "month"
        data = Commit.by_month
      else
        data = Commit.by_day
      end

      respond_with({ first_day: earliest_date, data: data })
    end
  end
end