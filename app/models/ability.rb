class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      can [:create, :read], Company
      can [:destroy, :update], Company, user_id: user.id
    elsif user.user?
      can [:create, :read, :update], Company, user_id: user.id
    end
  end
end
