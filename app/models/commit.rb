class Commit < ActiveRecord::Base
  # commit_hash : string
  # committed_at : datetime
  # message : string 

  attr_accessible :commit_hash, :committed_at, :message

  serialize :tags

  after_initialize :default_values

  def default_values
    self.tags ||= []
  end
end