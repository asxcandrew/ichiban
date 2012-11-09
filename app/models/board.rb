class Board < ActiveRecord::Base
  attr_accessible :directory, :name, :description, :file_size_limit, :save_IPs

  
  validates :name, length: { maximum: 100, 
                             too_long: I18n.t('boards.errors.name_too_long') }
  validates_presence_of :name, message: I18n.t('boards.errors.name')


  validates(:directory, 
            :format => { :with => /^[a-z0-9]+[-a-z0-9]*[a-z0-9]+$/i,
            message: I18n.t('boards.errors.directory_format') })

  validates_presence_of :directory, message: I18n.t('boards.errors.directory')
  
  validates_uniqueness_of(:directory,
                          case_sensitive: false,
                          message: I18n.t('boards.errors.directory_uniqueness'))

  has_many :posts, :dependent => :destroy
  has_many :suspensions, :dependent => :destroy
  has_and_belongs_to_many :users

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

  private
    def init
      self.save_IPs ||= true
      self.file_size_limit ||= 3.0
    end
  #end_private
end
