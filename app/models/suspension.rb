class Suspension < ActiveRecord::Base
  attr_accessible :ends_at, :ip_address, :reason, :directory, :post_id

  belongs_to :post

  validates_presence_of :post, message: "Post not found. Was it deleted?"
  validates_presence_of :ends_at

  def expired?
    Date.today > self.ends_at
  end

  def active?
    Date.today < self.ends_at
  end
end
