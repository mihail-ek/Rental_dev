class SubscriptionProjectObserver < ActiveRecord::Observer
  def after_save(subscription_project)
    update_stripe(subscription_project)
  end

  def after_destroy(subscription_project)
    update_stripe(subscription_project)
  end

  private
    def update_stripe(subscription_project)
      if subscription_project.created_at < Time.now - 1.minute
        subscription_project.subscription.update_stripe if subscription_project.subscription
      end
    end
end
