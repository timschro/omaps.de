class Club < ActiveRecord::Base

  has_many :maps

  belongs_to :state
end
