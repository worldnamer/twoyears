require 'spec_helper'

describe Commit do
  it 'can be created' do
    Commit.create(commit_hash: 'hash', committed_at: Time.now, message: 'message')
  end

  it 'has tags' do
    commit = Commit.new

    commit.tags.should be_empty

    commit.tags << {text: "tag"}

    commit.save
    commit.reload

    commit.tags.should == [{text: "tag"}]
  end
end