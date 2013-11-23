module Api
  class GithubCommitHookController < ApplicationController
    respond_to :json

    def hook
      repository = params["repository"]["name"]
      
      params["commits"].each do |commit|
        commit_hash = commit["id"]
        message = commit["message"]
        committed_at = Time.parse(commit["timestamp"])

        Commit.create(repository: repository, commit_hash: commit_hash, committed_at: committed_at, message: message)

        # tags = TagParser.parse(message)
      end

      render nothing: true
    end
  end
end