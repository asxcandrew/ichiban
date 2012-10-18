class Suspension < ActiveRecord::Base
  attr_accessible :ends_at, :ip_address, :reason, :directory, :post_id

  belongs_to :post

  validates_presence_of :post, message: "Post not found. Was it deleted?"
  validates_presence_of :reason, message: "A reason must be included with your supension."
  validates_presence_of :ends_at, message: "Could not parse end date. Try something like 'two days from now.'"

  def ends_at=(user_input)
    time = Chronic.parse(user_input)
    if time
      self[:ends_at] = time.to_date
    end
  end

  def expired?
    Date.today > self.ends_at
  end

  def active?
    Date.today < self.ends_at
  end
end
