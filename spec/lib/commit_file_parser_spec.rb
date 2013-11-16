require 'spec_helper'

describe CommitFileParser do
  it 'creates a commit for each record in the file' do
    parser = CommitFileParser.new

    parser.parse("spec/lib/commit_file_parser/success.txt")

    Commit.count.should == 3

    commit = Commit.where(commit_hash: "92e643c").first
    commit.should be_present
    commit.message.should == 'Fix for ticket 3460, clicking menu items on user page is fidgety. Removing :active on button_base so that opacity will stay at 100% for click events. This is required because for whatever reason, Chrome will send click events to background elements with higher opacity.'
    commit.committed_at.should == DateTime.strptime('Tue Feb 1 00:54:31 2012 UTC', '%a %b %d %H:%M:%S %Y %z')
  end

  it 'handles GMT dates' do
    parser = CommitFileParser.new

    parser.parse("spec/lib/commit_file_parser/success.txt")

    commit = Commit.where(commit_hash: "7b1f786").first
    commit.should be_present
    commit.committed_at.should == DateTime.strptime('Tue Feb 21 21:15:10 2012 +0000', '%a %b %d %H:%M:%S %Y %z')
  end

  it 'creates tags' do
    parser = CommitFileParser.new

    parser.parse("spec/lib/commit_file_parser/success.txt")

    commit = Commit.where(commit_hash: "8706c9a").first
    commit.should be_present
    commit.tags.count.should == 2
    commit.tags.first.text.should == "ui"
    commit.tags.last.text.should == "super fly"
  end
end