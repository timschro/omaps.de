class State < ActiveRecord::Base
  attr_accessible :abbreviation, :name
  has_many :clubs
end
