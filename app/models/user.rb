class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :role
  has_secure_password
  
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email, case_sensitive: false
  simple_roles # It's that simple :)

  has_and_belongs_to_many :boards
  has_many :posts, :through => :boards
  has_many :reports, :through => :posts

  def last_login
    self[:last_login].nil? ? self.created_at : self[:last_login]
  end

  # Operators have access to everything.
  # TODO: Refactor to be a little less...cumbersome.
  def boards
    self.operator? ? Board.where(nil) : super
  end

  def posts
    self.operator? ? Post.where(nil) : super
  end

  def reports
    self.operator? ? Report.where(nil) : super
  end
end
