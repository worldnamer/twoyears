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

  it 'can return totals by day' do
    Timecop.freeze(Date.yesterday) do
      # .select("text, count(1) as tag_count").group("text").sort_by(&:tag_count).map { |tag| [tag, tag.tag_count] }
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
      commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")
    end

    commit_three = Commit.create(repository: "asdf", commit_hash: "3", committed_at: Time.now, message: "2")

    commits = Commit.by_day.should == [2, 1]
  end

  it 'returns intermediate days for totals' do
    Timecop.freeze(Date.yesterday.yesterday) do
      # .select("text, count(1) as tag_count").group("text").sort_by(&:tag_count).map { |tag| [tag, tag.tag_count] }
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
      commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")
    end

    commit_three = Commit.create(repository: "asdf", commit_hash: "3", committed_at: Time.now, message: "2")

    commits = Commit.by_day.should == [2, 0, 1]
  end
end