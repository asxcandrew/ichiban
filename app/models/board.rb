class Board < ActiveRecord::Base
  attr_accessible :directory, :name, :description

  validates :name, :directory, presence: true
  validates :directory, uniqueness: true

  has_many :posts

  def to_params
    self.directory
  end

  def headline
    "#{self.name} - /#{self.directory}/"
  end
end
