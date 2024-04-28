class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      can :read, :all
    elsif user.manager?
      can :update
    end
  end
end
