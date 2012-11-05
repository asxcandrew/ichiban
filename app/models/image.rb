class Image < ActiveRecord::Base
  attr_accessible :asset, :post_id
  belongs_to :post
  mount_uploader :asset, ImageUploader
  validates_presence_of :asset
end
