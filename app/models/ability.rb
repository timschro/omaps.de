class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, Map
      can :read, Club
      can :read, MapType
      can :new, Club

      can :manage, Map, submitter_id: user.id

      can :access, :rails_admin   # grant access to rails_admin
      can :read, :dashboard       # grant access to the dashboard

      if user.admin?
        can :manage, [Map, MapType, Club]
        can :dashboard, [Map, MapType, Club]
        can :history, [Map, MapType, Club]
      end

      if user.superadmin?
        can :read, :all
        can :manage, :all
        can :dashboard, :all
        can :history, :all
      end

    end
  end
end
