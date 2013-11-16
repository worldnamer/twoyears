class Tag < ActiveRecord::Base
  belongs_to :commit

  # text : string
  attr_accessible :commit, :text

  def self.count_text
    count_by_text = {}
    select("text, count(1) as tag_count").group("text").sort_by(&:tag_count).reverse.take(20).each { |tag| count_by_text[tag.text] = tag.tag_count }
    count_by_text
  end

  def self.counts_by_day_as_rickshaw
    count_by_text = {}

    # get the earliest date
    earliest_date = Commit.select("committed_at").order("committed_at asc").first.committed_at

    # get the latest date
    latest_date = Commit.select("committed_at").order("committed_at desc").first.committed_at

    # create a blank array for those dates
    blank_data = []
    earliest_date.to_date.upto(latest_date.to_date) do |date|
      blank_data << 0
    end

    series = {} # "tag" => [{x: date_as_integer, y: count_on_day}, ...]
    Commit.includes(:tags).each do |commit|
      # find out what day the commit came in on, as an int
      committed_at = commit.committed_at.to_date.to_time.to_i

      # for each tag per commit
      commit.tags.each do |tag|
        # create the blank array for that tag, if needed
        series[tag.text.strip] ||= Marshal.load(Marshal.dump(blank_data))

        # fill in this day in that array
        length_of_day = 86400
        index_for_date = (committed_at - earliest_date.to_date.to_time.to_i)/86400
        series[tag.text.strip][index_for_date] ||= 0
        series[tag.text.strip][index_for_date] += 1
      end
    end

    series
  end
end