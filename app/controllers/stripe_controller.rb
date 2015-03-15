# encoding: UTF-8

class StripeController < ApplicationController
  before_filter :authenticate_user!, except: :merchant_account_authorization_confirmed
  before_filter :ensure_domain, only: :merchant_account_authorization

  # Charges (one-off payments)
  def create_charges
    StripeCustomer.create_with_the_api(current_user, params[:stripeToken])
    @cart.shopping_cart_items.each do |item|
      project = Project.find(item.item_id)
      amount = Money.new(item.price * 100, "GBP") 
      description = "£#{amount.cents/100}"
      
      merchant_customer = Charity.get_merchant_customer(project.charity, current_user) # find or create
      if merchant_customer
        merchant_access_token = project.charity.stripe_merchant.access_token
        stripe_customer = StripeCustomer.find_by_charity_id_and_user_id(project.charity.id, current_user.id) 
      
        charge = Stripe::Charge.create({
          :customer    => stripe_customer.customer_id,
          :amount      => amount.cents,
          :description => description,
          :currency    => 'gbp'
        }, merchant_access_token)
      end
    end
    @cart.clear
    
    redirect_to my_home_path, notice: "Thank you! Your contribution has gone through successfully!"
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path
  end

  # Subscriptions
  def create_subscriptions
    StripeCustomer.create_with_the_api(current_user, params[:stripeToken])
    User.create_subscriptions_from_cart(@cart, params[:gift_aid_charity_ids], current_user) # asynchronous
    redirect_to my_home_path, notice: "Thank you! We are processing your contribution. It will appear on this page in a few minutes."
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path
  end
  
  def cancel_subscription
    if project = Project.find(params[:project_id])
      subscription = Subscription.find_by_user_id_and_charity_id(current_user.id, project.charity.id)
      project_subscription = nil
      subscription.subscription_projects.each do |subscription_project| # TODO add user_id to subscription_projects?
        project_subscription = subscription_project if subscription_project.project == project
      end
      if project_subscription
        authorize! :destroy, project_subscription
        project_subscription.destroy
        redirect_to my_home_path, notice: "Your subscription to this project has been canceled."
      else
        redirect_to root_path, alert: "Unfortunately, something went wrong."
      end
    else
      redirect_to root_path, alert: "Unfortunately, something went wrong."
    end
  end
  # .subscriptions

  # Merchant account authorization
  def merchant_account_authorization
    options = {
      response_type: "code",
      client_id: ENV['STRIPE_APP_CLIENT_ID'],
      scope: "read_write",
      state: params[:state] # charity_id
    }

    connect_authorization_url = "https://connect.stripe.com/oauth/authorize"
    redirect_to "#{connect_authorization_url}?#{options.to_query}"
  end
  
  def merchant_account_authorization_confirmed
    auth_code = params[:code]
    
    options = {
      client_secret: ENV['STRIPE_SECRET_KEY'],
      code: auth_code,
      grant_type: "authorization_code"
    }
    connect_oauth_token = "https://connect.stripe.com/oauth/token"
    response = HTTParty.post(connect_oauth_token, query: options)

    stripe_merchant = StripeMerchant.find_or_create_by_charity_id(params[:state])
    stripe_merchant.access_token = response['access_token']
    stripe_merchant.publishable_key = response['stripe_publishable_key']
    stripe_merchant.user_id = response['stripe_user_id']
    stripe_merchant.token_type = response['token_type']
    stripe_merchant.scope = response['scope']
    stripe_merchant.livemode = response['livemode']
    stripe_merchant.refresh_token = response['refresh_token']
    stripe_merchant.save
   
    redirect_to charities_dashboard_path
  end
  # .Merchant account authorization
end
