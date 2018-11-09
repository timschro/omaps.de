class User < ActiveRecord::Base


  has_many :maps, :through => :submitter_id
  has_many :maps, :through => :last_editor_id


  validates :firstname, :presence => true
  validates :lastname, :presence => true


  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def icon_class
    return "icon-rocket" if self.is_admin?
    "icon-user"
  end



end
