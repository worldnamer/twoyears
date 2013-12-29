module Api
  class TagsController < ApplicationController
    respond_to :json

    before_filter :find_commit, except: [:index]

    def find_commit
      if params[:commit_id]
        @commit = Commit.where(user_id: current_user.id).where(commit_hash: params[:commit_id]).first
        @id = params[:id]

        @tag = @commit.tags.detect { |tag| tag.text == @id }
      end
    end

    def index
      respond_with Tag.count_text.map { |text, count| {text: text, count: count }}.sort { |a, b| a[:count].to_i <=> b[:count].to_i }.reverse
    end

    def update
      result = { }
      if @commit
        # rename tag if text != id otherwise create
        text = params[:text]
        if text == @id
          result[:location] = text.gsub(' ', '%20')

          if @tag
            result[:status] = :no_content
          else
            @commit.tags << Tag.new(text: text)
            @commit.save

            result[:status] = :created
          end
        else
          if @tag
            @commit.tags.delete(@tag)
            @commit.tags << Tag.new(text: text)
            @commit.save

            result[:location] = text.gsub(' ', '%20')
            result[:status] = :no_content
          else
            result[:status] = :not_found
          end
        end
      else
        result[:status] = :not_found
      end

      render result.merge({nothing: true})
    end

    def destroy
      result = { }

      if @tag and @commit
        debugger
        @commit.tags.delete(@tag)

        result[:status] = :no_content
      else
        result[:status] = :not_found
      end

      render result.merge({nothing: true})
    end

    def by_day_of_week
      tag = Tag.where(text: params[:id]).first

      respond_with({data: tag.by_day_of_week})
    end
  end
end