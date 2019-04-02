class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, Map
      can :read, Club
      can :new, Club

      can :manage, Map, submitter_id: user.id

      can :access, :rails_admin   # grant access to rails_admin
      can :read, :dashboard       # grant access to the dashboard

      if user.admin?
        can :read, :all
        can :manage, :all
      end

    end
  end
end
