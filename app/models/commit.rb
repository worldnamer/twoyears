class Commit < ActiveRecord::Base
  # commit_hash : string
  # committed_at : datetime
  # message : string 
  # repository : string

  attr_accessible :commit_hash, :committed_at, :message, :repository

  has_and_belongs_to_many :tags

  after_initialize :default_values

  def default_values
    self.tags ||= []
  end

  def self.by_day
    # get the earliest date
    earliest_date = earliest_time

    # get the latest date
    latest_date = select("committed_at").order("committed_at desc").first.committed_at

    # create a blank array for those dates
    count_data = []
    earliest_date.to_date.upto(latest_date.to_date) do |date|
      count_data << 0
    end

    Commit.order("committed_at DESC").all.each do |commit|
      committed_at = commit.committed_at.to_date.to_time.to_i
      index_for_date = (committed_at - earliest_date.to_date.to_time.to_i)/86400
      count_data[index_for_date] ||= 0
      count_data[index_for_date] += 1
    end

    count_data
  end

  def self.by_week
    # get the earliest date
    earliest_date = earliest_time.to_date
    earliest_year = earliest_date.year

    # get the latest date
    latest_date = select("committed_at").order("committed_at desc").first.committed_at.to_date
    latest_year = latest_date.year

    # create a blank array for those dates
    count_data = [0] * (latest_date.cweek - earliest_date.cweek + (latest_year-earliest_year)*52) 

    Commit.order("committed_at DESC").all.each do |commit|
      index_for_date = commit.committed_at.to_date.cweek - earliest_date.cweek
      index_for_date += (commit.committed_at.to_date.year - earliest_year)*52
      count_data[index_for_date] ||= 0
      count_data[index_for_date] += 1
    end

    count_data
  end

  def self.earliest_time
    select("committed_at").order("committed_at asc").first.committed_at
  end
end