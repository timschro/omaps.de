class Comment < ActiveRecord::Base

  belongs_to :map

  default_scope { where(:void => false, :resolved => false) }



  validates :comment, :submitter_email, :presence => true


end
