class Report < ActiveRecord::Base
  # attr_accessible :comment, :model, :post_id, :ip_address

  belongs_to :post
  has_one :board, :through => :post

  validates_presence_of :comment, message: I18n.t('reports.errors.comment')
  validates_presence_of :post, message: I18n.t('reports.errors.post_not_found')
  
  validates_length_of :comment, minimum: 4, message: I18n.t('reports.errors.descriptive_comment')
  validates_length_of :comment, maximum: 140, message: I18n.t('reports.errors.comment_too_long')

  validates_uniqueness_of :ip_address, 
                          :scope => :post_id,
                          message: I18n.t('reports.errors.duplicate_report')
  validate :max_reports_per_IP


  def date
    self.created_at.strftime("%F %T")
  end
  
  private
    def max_reports_per_IP
      post = Post.find_by_id(self.post_id)
      if post.board.reports.where(ip_address: self.ip_address).size >= post.board.settings(:limits).reports_per_ip
        errors.add(:max_reports, I18n.t('reports.errors.max_reports_per_IP'))
      end
    end
  #end_private
end
