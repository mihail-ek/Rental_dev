class GocardlessController < ApplicationController
  before_filter :set_up_client

  # PRE-AUTH
  def pre_auth_submit
    GoCardless.new_pre_authorization_url(
      :amount => "150.00",
      :name => "Stock Photos",
      :interval_unit => "day",
      :interval_length => 7,
    )
  end
  # .PRE-AUTH

  # SUBSCRIPTION
  def subscription_submit
    # We'll be billing everyone £10 per month in this example
    url_params = {
      :amount          => 10,
      :interval_unit   => "month",
      :interval_length => 1,
      :name            => "Premium Subscription",
      # Set the user email from the submitted value
      :user => {
        :email => params["email"]
      }
    }
    url = GoCardless.new_subscription_url(url_params)
    redirect_to url
  end

  def subscription_confirm
    GoCardless.confirm_resource params
    render "gocardless/success"
    rescue GoCardless::ApiError => e
    render :text => "Could not confirm new subscription. Details: #{e}"
  end
  # .SUBSCRIPTION

  # Merchant account authorization
  def merchant_account_authorization
    charity = Charity.find(params[:state])
    merchant_details = {
      :name => charity.name,
      :user => {
        :email => current_user.email
      }
    }

    redirect_to @client.new_merchant_url(
      :redirect_uri => gocardless_merchant_account_authorization_confirmed_url,
      :state => params[:state], # charity_id
      :merchant => merchant_details
    )
  end
  
  def merchant_account_authorization_confirmed
    auth_code = params[:code]
    @client.fetch_access_token(auth_code, :redirect_uri => gocardless_merchant_account_authorization_confirmed_url)
    go_cardless_merchant = GoCardlessMerchant.find_or_create_by_charity_id(params[:state])
    go_cardless_merchant.access_token = @client.access_token
    go_cardless_merchant.merchant_id = @client.merchant_id
    go_cardless_merchant.save
    redirect_to charities_dashboard_path
  end
  # .Merchant account authorization
  
  private
    def set_up_client
      @client  = GoCardless::Client.new(
        :app_id     => Settings.go_cardless.app_id,
        :app_secret => Settings.go_cardless.app_secret
      )
    end
end
