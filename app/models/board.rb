class Board < ActiveRecord::Base

  has_settings :class_name => 'BoardSettingObject' do |s|
    s.key :view, :defaults => { :color => 'gray'}
    s.key :limits, :defaults => { :reports_per_ip => 3, :file_size_limit => 3.megabytes}
  end

  resourcify
  
  validates(:name, 
            length:  { maximum: 40, 
                       too_long: I18n.t('boards.errors.name_too_long') },
           presence: { message: I18n.t('boards.errors.name') })

  validates(:directory, 
            format:     { with: /[-a-z0-9]*[a-z0-9]/i,
                          message: I18n.t('boards.errors.directory_format') },
            presence:   { message: I18n.t('boards.errors.directory') },
            length:     { maximum: 4, 
                          too_long: I18n.t('boards.errors.directory_too_long', max: 40) },
            uniqueness: { case_sensitive: false,
                          message: I18n.t('boards.errors.directory_uniqueness') })

  has_many :posts, :dependent => :destroy
  has_many :suspensions, :dependent => :destroy
  has_and_belongs_to_many :users
  has_many :reports, :through => :posts, :dependent => :destroy
  
  scope :top, -> {
    group("posts.board_id").
    joins(:posts).
    order("count(posts.board_id) desc").
    limit(5)
  }

  def color
    settings(:view).color
  end

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

end

class BoardSettingObject < RailsSettings::SettingObject
  validate do
    errors.add(:base, "Color name is missing") unless PostsHelper::COLORS.keys.include?(self.value['color'].to_sym)
    # unless self.value['reports_per_ip'].is_a?(Numeric) || self.value['reports_per_ip'].between?(1,15)
    #   errors.add(:base, "To many reports_per_ip") 
    # end
    # unless self.value['file_size_limit'].is_a?(Numeric) || self.value['file_size_limit'].between?(1.megabytes,5.megabytes)
    #   errors.add(:base, "file_size_limit is 5 mb")
    # end
  end
end
