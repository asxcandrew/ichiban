class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    # Normal Users
    can(:read, [Board, Post, Tripcode])
    can(:create, Report)
    can(:create, Post)
    # Users can delete a post if they have they have created the post.
    # Take a look at posts#destroy for an explanation.

    if @user.janitor?
      can(:destroy, Post)
      can(:manage, Report)
    end

    if @user.moderator?
      can(:manage, Post)
      can(:manage, Report)
      can(:manage, Suspension)
    end

    if @user.admin?
      can(:manage, :all)
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
