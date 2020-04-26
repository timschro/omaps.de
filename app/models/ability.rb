# Ability model for cancan authorization
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, Map
    can :new, Map
    can :create, Map

    can :read, Club
    can :read, MapType
    can :read, Discipline
    can :new, Club
    can :create, Club
    can :dashboard, :all


    can :manage, Map.visible do |map|
      map.belongs_to_user user
    end


    can :read, Club
    can :new, Club
    can :create, Club

    can :dashboard, :all
    can :access, :rails_admin # grant access to rails_admin
    can :read, :dashboard # grant access to the dashboard

    return unless user.admin?

    can :manage, [Map, MapType, Club, Discipline]
    can :read, User
    can :history, [Map, MapType, Club, Discipline]

    return unless user.superadmin?

    can :read, :all
    can :manage, :all
    can :history, :all
  end
end
