require 'spec_helper'

describe Commit do
  it 'can be created' do
    Commit.create(commit_hash: 'hash', committed_at: Time.now, message: 'message')
  end

  it 'has tags' do
    commit = Commit.new

    commit.tags.should be_empty

    tag = Tag.new(text: "tag")
    commit.tags << tag

    commit.save

    commit.reload.tags.should == [tag]
  end
end