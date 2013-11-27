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
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
      commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")
    end

    commit_three = Commit.create(repository: "asdf", commit_hash: "3", committed_at: Time.now, message: "2")

    Commit.by_day.should == [2, 1]
  end

  it 'returns intermediate days for totals' do
    Timecop.freeze(Date.yesterday.yesterday) do
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
      commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")
    end

    commit_three = Commit.create(repository: "asdf", commit_hash: "3", committed_at: Time.now, message: "2")

    Commit.by_day.should == [2, 0, 1]
  end

  it 'can return totals by week' do
    Timecop.freeze(Date.new(2013,11,25) - 8.days) do
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
      commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")
    end

    Timecop.freeze(Date.new(2013,11,25)) do
      commit_three = Commit.create(repository: "asdf", commit_hash: "3", committed_at: Time.now, message: "2")
    end

    Commit.by_week.should == [2, 0, 1]
  end

  it 'by week report functions past year boundary' do
    Timecop.freeze(Date.new(2013,12,29)) do
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
      commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")
    end

    Timecop.freeze(Date.new(2014,1,1)) do
      commit_three = Commit.create(repository: "asdf", commit_hash: "3", committed_at: Time.now, message: "2")
    end

    Commit.by_week.should == [2, 1]
  end

  it 'knows the earliest commit' do
    commit_one = nil
    Timecop.freeze(Date.yesterday) do
      commit_one = Commit.create(repository: "asdf", commit_hash: "1", committed_at: Time.now, message: "1")
    end

    commit_two = Commit.create(repository: "asdf", commit_hash: "2", committed_at: Time.now, message: "2")

    Commit.earliest_time.should == commit_one.committed_at
  end
end