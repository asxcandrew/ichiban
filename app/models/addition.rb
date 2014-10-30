class Addition < ActiveRecord::Base

  has_one :image, :as => :imageable
  accepts_nested_attributes_for :image
  has_one :post
end
