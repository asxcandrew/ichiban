class Report < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  attr_accessible :comment, :model, :post_id, :ip_address

  belongs_to :post

  validate :max_amount_of_reports
  validates_presence_of :comment
  validates_uniqueness_of :ip_address, 
                          :scope => :post_id,
                          message: "You have already reported that post."


  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end

  # HACK: I'd like to be able to get the total amount of reports
  #       without trying having the client build the header.
  def total
    pluralize(Report.all.size, "Report")
  end
  
  private
    # TODO: Replace max amount of reports number with variable from admin panel.
    def max_amount_of_reports
      if Report.where(ip_address: self.ip_address).size > 5
        errors.add(:max_reports, "You have too many open reports.")
      end
    end
  #end_private
end
