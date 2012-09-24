class Report < ActiveRecord::Base
  attr_accessible :comment, :model, :post_id, :ip_address

  belongs_to :post
  validates_presence_of :comment

  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end
end
