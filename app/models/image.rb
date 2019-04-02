class Image < ActiveRecord::Base
  belongs_to :map, inverse_of: :images
end
