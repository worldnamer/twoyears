require 'spec_helper'

describe TagParser do
  it 'parses tags' do
    tags = TagParser.parse("#tag")

    tags.count.should == 1
    tags.first.text.should == "tag"
  end

  it 'returns all the tags' do
    tags = TagParser.parse("#tag1 #tag2")

    tags.count.should == 2
  end

  it 'only creates tags if it has to' do
    tags = TagParser.parse("#tag")
    tags = TagParser.parse("#tag")

    Tag.count.should == 1
  end

  it 'handles multiple lines' do
    tags = TagParser.parse('Some text\n\n: #tag')

    tags.count.should == 1
  end
end