require 'spec_helper'

describe Api::GithubCommitHookController do
  describe 'POST hook' do
    it 'receives the hook information' do
      example = File.open("spec/lib/github_commit_hook/example.json") { |f| f.read }

      post :hook, {payload: example}

      Commit.count.should == 1
      commit = Commit.first
      commit.repository.should == "twoyears"
      commit.commit_hash.should == "67fe1fdb754e711d7518bae9b9d2f89183d4941f"
      commit.message.should start_with "Add scaling to tags display to keep it from line-breaking."
    end

    it 'creates tags from the message' do
      example = File.open("spec/lib/github_commit_hook/example.json") { |f| f.read }

      post :hook, {payload: example}

      commit = Commit.first
      commit.tags.count.should == 2
      Tag.where(text: "ui").count.should == 1
      Tag.where(text: "bug").count.should == 1
    end

    it 'eats lines that start with a colon' do
      example = File.open("spec/lib/github_commit_hook/example.json") { |f| f.read }

      post :hook, {payload: example}

      commit = Commit.first
      commit.message.should_not end_with ": #ui #bug"
    end
  end
end