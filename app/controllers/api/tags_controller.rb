module Api
  class TagsController < ApplicationController
    respond_to :json

    before_filter :find_commit

    def find_commit
      if params[:commit_id]
        @commit = Commit.where(commit_hash: params[:commit_id]).first
      end
    end

    def update
      result = { }
      if @commit
        id = params[:id]
        tag = @commit.tags.detect { |tag| tag[:text] == id }

        # rename tag if text != id otherwise create
        text = params[:text]
        if text == id
          result[:location] = text.gsub(' ', '%20')

          if tag
            result[:status] = :no_content
          else
            @commit.tags << {text: text}
            @commit.save

            result[:status] = :created
          end
        else
          if tag
            @commit.tags.delete(tag)
            @commit.tags << {text: text}
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
  end
end