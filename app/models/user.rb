class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :maps, :through => :submitter_id
  has_many :maps, :through => :last_editor_id


  validates :firstname, :presence => true
  validates :lastname, :presence => true


  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def admin?
    self.is_admin
  end


end
