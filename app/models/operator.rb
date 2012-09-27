class Operator < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :role_id
  has_secure_password
  
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email, case_sensitive: false
  belongs_to :role

end
