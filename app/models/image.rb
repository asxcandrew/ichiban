class Image < ActiveRecord::Base
  attr_accessible :asset, :asset_cache, :post_id
  belongs_to :post
  mount_uploader :asset, ImageUploader
end
