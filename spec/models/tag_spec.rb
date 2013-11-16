require 'spec_helper'

describe Tag do
  it 'knows how many of which tags there are' do
    # .select("text, count(1) as tag_count").group("text").sort_by(&:tag_count).map { |tag| [tag, tag.tag_count] }
    commit_one = Commit.create(commit_hash: "1", committed_at: Time.now, message: "1")
    Tag.create(commit: commit_one, text: "one")

    commit_two = Commit.create(commit_hash: "2", committed_at: Time.now, message: "2")
    Tag.create(commit: commit_two, text: "one")
    Tag.create(commit: commit_two, text: "two")

    Tag.count_text.should == {"one" => 2, "two" => 1}
  end

  it 'can return daily counts of each tag' do
    Timecop.freeze(Date.yesterday) do
      # .select("text, count(1) as tag_count").group("text").sort_by(&:tag_count).map { |tag| [tag, tag.tag_count] }
      commit_one = Commit.create(commit_hash: "1", committed_at: Time.now, message: "1")
      Tag.create(commit: commit_one, text: "one")
    end

    commit_two = Commit.create(commit_hash: "2", committed_at: Time.now, message: "2")
    Tag.create(commit: commit_two, text: "one")
    Tag.create(commit: commit_two, text: "two")

    Tag.counts_by_day_as_rickshaw.should == {
      "one" => [1, 1], 
      "two" => [0, 1]
    }
  end
end