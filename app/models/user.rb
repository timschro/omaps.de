class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_paper_trail

  has_many :maps, :through => :submitter_id
  has_many :maps, :through => :last_editor_id
  has_many :maps


  validates :firstname, :presence => true
  validates :lastname, :presence => true


  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def admin?
    self.is_admin || self.is_superadmin
  end

  def superadmin?
    self.is_superadmin
  end

  def name
    firstname + " " + lastname
  end


  rails_admin do

    include_fields :lastname, :firstname, :email, :last_sign_in_at, :sign_in_count, :is_admin, :is_superadmin


    list do
      exclude_fields :created_at, :updated_at
      field :firstname do
        column_width 150
      end

      field :lastname do
        column_width 150
      end

      field :email do
        column_width 150

      end

    end

    # edit do
    #   field :google_map, :google_map do
    #     google_api_key 'AIzaSyApg5YWYo8a9avXl-ICqdgaEoTqt9mz53w'
    #     default_latitude -34.0
    #     default_longitude 151.0
    #     locale 'de'
    #   end
    # end
  end

end
