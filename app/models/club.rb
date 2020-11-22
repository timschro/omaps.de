class Club < ActiveRecord::Base

  has_many :maps

  #belongs_to :state
  
  validates :name, presence: true

  rails_admin do
    label 'Verein'
    label_plural 'Vereine'
    exclude_fields :maps, :state_id
    list do
      exclude_fields :created_at, :updated_at, :email, :state
    end
  end

end
