class Commit < ActiveRecord::Base
  # commit_hash : string
  # committed_at : datetime
  # message : string 

  attr_accessible :commit_hash, :committed_at, :message
end