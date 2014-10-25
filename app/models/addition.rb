class Addition < ActiveRecord::Base
  attr_accessible :image_attributes

  has_one :image, :as => :imageable
  accepts_nested_attributes_for :image
  has_one :post
end
