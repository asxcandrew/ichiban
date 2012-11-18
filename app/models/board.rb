class Board < ActiveRecord::Base
  attr_accessible :directory, :name, :description, :file_size_limit, :save_IPs, :max_reports_per_IP

  
  validates(:name, 
            length:  { maximum: 100, 
                       too_long: I18n.t('boards.errors.name_too_long') },
           presence: { message: I18n.t('boards.errors.name') })

  validate :max_file_size_limit

  validates(:directory, 
            format:     { with: /^[a-z0-9]+[-a-z0-9]*[a-z0-9]+$/i,
                          message: I18n.t('boards.errors.directory_format') },
            presence:   { message: I18n.t('boards.errors.directory') },
            uniqueness: { case_sensitive: false,
                          message: I18n.t('boards.errors.directory_uniqueness') })

  has_many :posts, :dependent => :destroy
  has_many :suspensions, :dependent => :destroy
  has_and_belongs_to_many :users
  has_many :reports, :through => :posts, :dependent => :destroy

  after_initialize :init


  # Used to build RESTful routes
  def to_param
    self.directory
  end

  def directory=(directory)
    if new_record?
      self[:directory] = directory
    else
      raise I18n.t('boards.errors.directory_modification')
    end
  end

  def max_file_size_limit
    # TODO: Set in management panel.
    limit = 6
    if self.file_size_limit > limit
      errors.add(:max_file_size_limit, I18n.t('boards.errors.max_file_size_limit', limit: limit))
    end
  end

  private
    def init
      self.file_size_limit ||= 3.0
      self.max_reports_per_IP ||= 10
    end
  #end_private
end
