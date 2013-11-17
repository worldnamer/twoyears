class Commit < ActiveRecord::Base
  # commit_hash : string
  # committed_at : datetime
  # message : string 

  attr_accessible :commit_hash, :committed_at, :message

  has_and_belongs_to_many :tags

  after_initialize :default_values

  def default_values
    self.tags ||= []
  end
end