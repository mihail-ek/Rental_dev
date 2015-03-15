class ProjectDonationObserver < ActiveRecord::Observer
  def after_save(project_donation)
    if project_donation.paid_changed? && project_donation.paid
      achievement = Achievement.new
      achievement.user = project_donation.user
      achievement.project = project_donation.project
      achievement.title = "#{project_donation.user.name} helped the project '#{project_donation.project.name}' to get funded."
      achievement.save
    end

    if project_donation.gift_aid_changed? && project_donation.created_at < 2.minutes.ago
      user = project_donation.user
      user.subscriptions.each do |subscription|
        subscription.update_stripe
      end
    end

    # Check if project is funded
    project = project_donation.project
    if project_donation.paid && !project.is_funded && project.donations_total > project.makes_cost
      project.is_funded = true
      project.save

      # 1 - Put the extra money in another charity project if possible
      active_projects = project.charity.projects.public.unfunded
      if active_projects.any?
        make = project_donation.projects_make
        # TODO: Check that I always need to add the amount of the project donation
        extra_money = make.donations_total_uncensored + project_donation.amount - make.cost
        
        if extra_money > 0
          project = active_projects.first # TODO: smarter matching

          donation = ProjectDonation.new user_id: project_donation.user_id,
                                          project_id: project.id,
                                          projects_make_id: project.current_project_make.id,
                                          amount_pennies: extra_money.fractional,
                                          stripe_charge_id: project_donation.stripe_charge_id,
                                          gift_aid: project_donation.gift_aid
          project_donation.amount -= extra_money
          if project_donation.save
            subscription_project = SubscriptionProject.joins(:subscription).where('subscriptions.user_id' => donation.user_id, project_id: project_donation.project_id).readonly(false).first
            if subscription_project
              subscription_project.project_id = project.id
              subscription_project.save
            end
          end
        end
      
        # 2 - Reorganize all the remaining subscriptions for this project
        project_donation.project.subscription_projects.each do |subscription_project|
          suggested_project = subscription_project.subscription.user.suggested_project

          if suggested_project
            previous_subscription = subscription_project.subscription
            
            subscription = Subscription.find_or_create_by_charity_id_and_user_id(suggested_project.charity_id, subscription_project.subscription.user_id)
            subscription.interval = previous_subscription.interval
            subscription.stripe_customer = previous_subscription.stripe_customer
            
            if subscription.save
              subscription_project.subscription_id = subscription.id
              subscription_project.project_id = suggested_project.id
              subscription_project.save # the observer will update stripe

              previous_subscription.update_stripe
            end
          else
            subscription_project.destroy
          end
        end
      end
    end
  end
end
