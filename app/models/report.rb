class Report < ActiveRecord::Base
  attr_accessible :comment, :model, :post_id, :ip_address

  has_one :post
  validates_presence_of :comment
end
