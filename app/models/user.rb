class User < ActiveRecord::Base
  rolify
  # attr_accessible :role, :email, :password, :remember_me, :password_confirmation

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
  
  has_one :image, :as => :imageable, :dependent => :destroy
  accepts_nested_attributes_for :image
  
  has_and_belongs_to_many :boards
  has_many :posts, :through => :boards
  has_many :suspensions, :through => :boards
  has_many :reports, :through => :posts
  has_many :users, :through => :boards

  # def last_login
  #   self[:last_login].nil? ? self.created_at : self[:last_login]
  # end

  def check_if_operator!
    raise CanCan::AccessDenied unless self.operator?
  end

  # TODO: Refactor to be a little less...cumbersome.
  # Operators have access to everything.
  def boards
    self.operator? ? Board.where(nil) : super
  end

  def posts
    self.operator? ? Post.where(nil) : super
  end

  def reports
    self.operator? ? Report.where(nil) : super
  end

  def suspensions
    self.operator? ? Suspension.where(nil) : super
  end

  def users
    if self.operator? # Operators have all users.
      User.where(nil)
    elsif self.administrator? # Administrators have users from their board.
      super
    else # Everybody else has no users.
      super.limit(0)
    end
  end
end