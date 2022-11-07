class Ability
  include CanCan::Ability
  def initialize user
    can :read, [Movie, Comment]

    return if user.blank?

    can %i(read create), Payment
    can :destroy, ShowTime

    can %i(read create), ShowTime
    can :create, Comment
    can :search, Movie

    can :manage, :all if user.admin?
  end
end
