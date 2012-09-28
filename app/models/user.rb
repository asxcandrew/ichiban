class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :role
  has_secure_password
  
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email, case_sensitive: false
  simple_roles

end
