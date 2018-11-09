class Comment < ActiveRecord::Base
  attr_accessible :comment, :submitter_email

  belongs_to :map

  default_scope where(:void => false)
  default_scope where(:resolved => false)


  validates :comment, :submitter_email, :presence => true


end
