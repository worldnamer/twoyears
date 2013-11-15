module Api
  class CommitsController < ApplicationController
    respond_to :json

    def index
      respond_with Commit.includes(:tags).all, include: :tags
    end
  end
end