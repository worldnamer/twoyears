module Api
  class GithubCommitHookController < ApplicationController
    respond_to :json

    def hook
      parsed_payload = JSON.parse(params[:payload])

      repository = parsed_payload["repository"]["name"]
      
      parsed_payload["commits"].each do |commit_as_hash|
        commit_hash = commit_as_hash["id"]
        message = commit_as_hash["message"].split("\n").reject { |line| line.start_with? ":" }.join("\n")
        committed_at = Time.parse(commit_as_hash["timestamp"])

        user = User.find_by_email(commit_as_hash['author']['email'])
        commit = Commit.create(repository: repository, commit_hash: commit_hash, committed_at: committed_at, message: message, user: user)

        tags = TagParser.parse(commit_as_hash["message"])

        tags.each do |tag|
          commit.tags << tag
        end
        commit.save
      end

      render nothing: true
    end
  end
end