class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :role
  has_secure_password
  
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email, case_sensitive: false
  simple_roles # It's that simple :)

  has_and_belongs_to_many :boards
  has_many :posts, :through => :boards

  def last_login
    self[:last_login].nil? ? self.created_at : self[:last_login]
  end

  # Operators have all boards.
  def boards
    self.operator? ? Board.all : super
  end
end
