class Board < ActiveRecord::Base
  attr_accessible :directory, :name, :description

  validates_presence_of :name
  validates_presence_of :directory
  validates_uniqueness_of :directory

  has_many :posts, :dependent => :destroy
  has_many :suspensions, :dependent => :destroy

  # Used to build RESTful routes
  def to_param
    self.directory
  end
end
