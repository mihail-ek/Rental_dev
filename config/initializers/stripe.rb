Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.setup do
  subscribe 'invoice.payment_succeeded' do |event|
    if Rails.env.development? || Rails.env.staging? || (Rails.env.production? && event[:livemode] == true)
      stripe_charge_id = event.data[:object][:charge]
      donation = Donation.find_by_stripe_charge_id(stripe_charge_id) if stripe_charge_id
      if donation
        donation.application_fee_pennies = event.data[:object][:application_fee]
        donation.save
      end
    end
  end

  subscribe 'charge.succeeded', 'charge.failed', 'charge.refunded', 'charge.captured' do |event|
    if Rails.env.development? || Rails.env.staging? || (Rails.env.production? && event[:livemode] == true)
      stripe_charge_id = event.data[:object][:id]
      stripe_customer = StripeCustomer.find_by_customer_id(event.data[:object][:customer])
      amount_pennies = event.data[:object][:amount]
      currency = event.data[:object][:currency].upcase
      card = event.data[:object][:card]
      user_billing_address = "#{card[:address_line1]}#{" " unless card[:address_line2].nil?}#{card[:address_line2]},
                              #{card[:address_city]}, #{card[:address_zip]},
                              #{card[:address_state]}, #{card[:address_country]}"
      user = stripe_customer.user
      charity = stripe_customer.charity
      datetime = Time.at(event.data[:object][:created])
      subscription = Subscription.where(charity_id: charity.id, user_id: user.id).first
      amount_refunded_pennies = event.data[:object][:amount_refunded]

      d = Donation.find_or_create_by_stripe_charge_id(stripe_charge_id)
      d.charity = charity
      d.charity_name = charity.name
      d.user = user
      d.user_name = user.name
      d.user_billing_address = user_billing_address
      d.date = datetime
      d.amount = Money.new(amount_pennies, currency)
      d.paid = event.data[:object][:paid]
      d.refunded = event.data[:object][:refunded]
      d.amount_refunded = Money.new(amount_refunded_pennies, currency)
      d.failure_message = event.data[:object][:failure_message]
      d.failure_code = event.data[:object][:failure_code]
      d.save

      if subscription
        subscription.subscription_projects.active.each do |subscription_project|
          project = subscription_project.project

          if project && project.current_project_make
            projects_make = project.current_project_make

            p = ProjectDonation.find_or_create_by_stripe_charge_id_and_projects_make_id(stripe_charge_id, projects_make.id)
            p.user = user
            p.project = project
            p.amount = subscription_project.amount
            p.gift_aid = subscription_project.gift_aid
            p.paid = d.paid
            p.save

            if Rails.env.production?
              @tracker.track(0, 'Checkout', {
                  'Choice type' => 'Cause',
                  'Number of projects added' => '1',
                  'Name of projects' => project.name,
                  'Donation amount' => p.amount_pennies,
                  'Donation type' => 'ongoing',
                  'Gift aid activated' => p.gift_aid ? 'Yes' : 'No'
              })
            end
          end
        end
      else
        # TODO Handle top up
        # session[:top_up_story_id]
      end
    end
  end
  
  subscribe 'customer.subscription.created', 'customer.subscription.updated', 'customer.subscription.deleted' do |event|
    if Rails.env.development? || Rails.env.staging? || (Rails.env.production? && event[:livemode] == true)
      stripe_customer = StripeCustomer.find_by_customer_id(event.data[:object][:customer])
      user = stripe_customer.user
      charity = stripe_customer.charity
      
      s = Subscription.find_by_charity_id_and_user_id(charity.id, user.id)
      s.stripe_subscription_status = event.data[:object][:status]
      s.save
    end
  end

  subscribe do |event|
    # Handle all event types - logging, etc.
  end
end

# https://stripe.com/docs/webhooks
# "If security is a concern, or if it's important to confirm that
# Stripe sent the webhook, you should only use the ID sent in your webhook
# and should request the remaining details from the Stripe API directly."
StripeEvent.event_retriever = lambda do |params|
  # https://stripe.com/docs/connect/getting-started
  # It's important to note that while only test webhooks will be sent to your development webhook url,
  # both live and test webhooks will be sent to your production webhook url.
  if Rails.env.development? || Rails.env.staging? || Rails.env.production?
    stripe_merchant = StripeMerchant.find_by_user_id(params[:user_id])
    secret_key = if stripe_merchant
                   stripe_merchant.access_token # merchant
                 else
                   ENV['STRIPE_SECRET_KEY'] # makerble
                 end
    Stripe::Event.retrieve(params[:id], secret_key)
  else
    StripeEvent.event_retriever = lambda { |params| params }
  end
end
