module Api
  class CommitsController < ApplicationController
    respond_to :json

    def index
      respond_with Commit.all
    end
  end
end