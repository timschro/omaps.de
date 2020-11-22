class Club < ActiveRecord::Base

  has_many :maps

  #belongs_to :state

  rails_admin do
    label 'Verein'
    label_plural 'Vereine'
    exclude_fields :maps, :state
    list do
      exclude_fields :created_at, :updated_at, :email
    end
  end

end
