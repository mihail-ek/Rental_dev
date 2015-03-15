class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not signed in)
    if user.has_role? :admin
      can :manage, :all
      cannot :approve_project, :all
      can :approve_project, Project
    else
      can [:read, :create], User
      can [:update, :destroy], User, id: user.id

      can [:read, :create], WaitingList

      can :read, Cause

      can :read, Charity do |charity|
        charity.is_public || charity.editors.include?(user) || charity.reporters.include?(user)
      end
      can :create, Charity
      can [:update, :destroy], Charity do |charity|
        charity.editors.include?(user)
      end
      can :manage_colleagues, Charity do |charity|
        charity.editors.include?(user) || charity.reporters.include?(user)
      end
      can :dashboard, Charity do |charity|
        charity.editors.include?(user) || charity.reporters.include?(user)
      end

      can :read, Project do |project|
        (project.approved && project.charity && project.charity.is_public) ||
        (project.charity && (project.charity.editors.include?(user) || project.charity.reporters.include?(user))) ||
        project.editors.include?(user) || project.reporters.include?(user)
      end
      can :create, Project
      can :update, Project do |project|
        (project.charity && (project.charity.editors.include?(user) || project.charity.reporters.include?(user))) ||
        project.editors.include?(user) || project.reporters.include?(user)
      end
      can :manage_colleagues, Project do |project|
        (project.charity && project.charity.editors.include?(user)) || project.editors.include?(user)
      end
      can [:destroy, :approve], Project do |project|
        project.charity.editors.include?(user) if project.charity
      end
      can :dashboard, Project do |project|
        project.editors.include?(user) || project.reporters.include?(user)
      end
      can :trends, Project do |project|
        project.editors.include?(user)
      end

      can [:read, :create], WelcomeMessage

      can [:read, :create], Story
      can [:update, :destroy, :approve], Story do |story|
        if story.project && story.project.charity
          story.project.charity.editors.include?(user) || story.project.editors.include?(user)
        else
          false
        end
      end

      can :read, LifestyleCheckout

      can [:read, :create], Faq
      can [:update, :destroy], Faq do |faq|
        can = false
        can = can && faq.project.charity.editors.include?(user) if faq.project.charity
        can = can && faq.project.question.user == user
        can
      end
      can [:read, :create], Comment
      can [:update, :destroy], Comment, user_id: user.id
    end
  end
end
