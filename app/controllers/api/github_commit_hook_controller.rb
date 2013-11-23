module Api
  class GithubCommitHookController < ApplicationController
    respond_to :json

    def hook
      parsed_payload = JSON.parse(params[:payload])

      repository = parsed_payload["repository"]["name"]
      
      parsed_payload["commits"].each do |commit|
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