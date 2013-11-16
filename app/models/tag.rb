class Tag < ActiveRecord::Base
  belongs_to :commit

  # text : string
  attr_accessible :commit, :text

  def self.count_text
    count_by_text = {}
    select("text, count(1) as tag_count").group("text").sort_by(&:tag_count).reverse.take(20).each { |tag| count_by_text[tag.text] = tag.tag_count }
    count_by_text
  end
end