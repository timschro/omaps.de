class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, Map
    can :new, Map
    can :read, Club
    can :read, MapType
    can :new, Club
    can :dashboard, :all

    can :manage, Map, submitter_id: user.id

    can :access, :rails_admin   # grant access to rails_admin
    can :read, :dashboard       # grant access to the dashboard

    if user.admin?
      can :manage, [Map, MapType, Club]
      can :history, [Map, MapType, Club]
    end

    return unless user.superadmin?
    can :read, :all
    can :manage, :all
    can :history, :all
  end
end
