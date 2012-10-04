class Suspension < ActiveRecord::Base
  attr_accessible :ends_at, :ip_address, :reason, :directory, :post_id

  belongs_to :post
end
