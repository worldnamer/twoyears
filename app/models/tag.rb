class Tag < ActiveRecord::Base
  belongs_to :commit

  # text : string
  attr_accessible :text
end