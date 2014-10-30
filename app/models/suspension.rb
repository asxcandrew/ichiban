class Suspension < ActiveRecord::Base
  # attr_accessible :ends_at, :ip_address, :reason, :directory, :post_id, :board_id

  belongs_to :post
  belongs_to :board

  validates_presence_of :ip_address, message: I18n.t('suspensions.errors.no_ip_address')
  validates_presence_of :post, message: I18n.t('suspensions.errors.post_not_found')
  validates_presence_of :board, message: I18n.t('suspensions.errors.board_not_found')
  validates_presence_of :reason, message: I18n.t('suspensions.errors.no_reason_given')
  validates_presence_of :ends_at, message: I18n.t('suspensions.errors.date_parsing')

  # TODO: validate existance of board.

  validate :future_end_date

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

  def future_end_date
    if self.ends_at && self.ends_at < Date.today
      errors.add(:future_end_date, I18n.t('suspensions.errors.past_date'))
    end
  end
end
