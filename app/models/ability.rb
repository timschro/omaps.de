class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, Map
      can :manage, Map, submitter_id: user.id

      if user.admin?
        can :manage, :all
      end

    end
  end
end
