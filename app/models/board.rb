class Board < ActiveRecord::Base
  attr_accessible :directory, :name, :description

  
  validates :name, length: { maximum: 100, 
                             too_long: "A board's name must not exceed 300 characters." }
  validates_presence_of :name, message: "A board must have a name."


  validates(:directory, 
            :format => { :with => /^[a-z0-9]+[-a-z0-9]*[a-z0-9]+$/i,
            message: "A board's directory must be alphanumeric and at least 2 characters." })
  validates_presence_of :directory, message: "A board must have a directory."
  validates_uniqueness_of(:directory,
                          case_sensitive: false,
                          message: "A board's directory must be unique.")

  has_many :posts, primary_key: 'directory', foreign_key: 'directory', :dependent => :destroy
  has_many :suspensions, primary_key: 'directory', foreign_key: 'directory', :dependent => :destroy

  # Used to build RESTful routes
  def to_param
    self.directory
  end

  def directory=(input)
    if new_record?
      write_attribute(:directory, input)
    else
      raise 'Board directory cannot be changed.'
    end
  end 
end
