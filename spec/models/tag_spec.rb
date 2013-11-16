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
end