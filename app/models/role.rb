class Role < ActiveRecord::Base
  attr_accessible :name

  has_many :operators
  validates_uniqueness_of :name, case_sensitive: false
end
