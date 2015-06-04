class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    # Normal Users
    can :read, :all
    can :create, [User, Report, Post, Board]
    can :search, Board
    # Users can delete a post if they have they have created the post or if they moderate the board.
    # Take a look at posts#destroy for an explanation.
    if @user.has_role? :operator
      can :manage, :all
    end

    if @user.has_role? :administrator
      can :manage, Post
      can :manage, Report
      can :manage, Suspension
      # can :manage, Board
      # can :manage, User
    end
      
    can :manage, Board, :id => Board.with_role(:owner, user).pluck(:id)
    can :manage, Report, :board => { :id => Board.with_role(:owner, user).pluck(:id) }
    can :destroy, Post, :board => { :id => Board.with_role(:owner, user).pluck(:id) }
    can :manage, Suspension, :board => { :id => Board.with_role(:owner, user).pluck(:id) }

    
    # if @user.has_role? :moderator
    can :manage, Report, :board => { :id => Board.with_role(:moderator, user).pluck(:id) }
    can :destroy, Post, :board => { :id => Board.with_role(:moderator, user).pluck(:id) }
    can :manage, Suspension, :board => { :id => Board.with_role(:moderator, user).pluck(:id) }
    # end
  end
end
