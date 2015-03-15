# encoding: UTF-8

class Subscription < ActiveRecord::Base
  belongs_to :charity
  belongs_to :user
  belongs_to :stripe_customer
  has_many :subscription_projects
  has_many :projects, through: :subscription_projects
  
  scope :active, -> { where(stripe_subscription_status: 'active') }

  attr_accessible :interval, :charity_id, :user_id, :stripe_subscription_status

  def amount
    pennies = 0
    subscription_projects.active.each do |subscription_project|
      pennies += subscription_project.amount_pennies
    end
    Money.new(pennies, "GBP")
  end

  def update_stripe
    logger.info "Update stripe"
    logger.info "Update stripe"
    logger.info "Update stripe"
    
    if stripe_merchant = self.charity.stripe_merchant
      merchant_access_token = stripe_merchant.access_token
      
      if merchant_customer = Charity.get_merchant_customer(self.charity, self.user)
        if self.amount.cents == 0
          begin
            response = merchant_customer.cancel_subscription
            self.stripe_subscription_status = response['status']
            self.save
          rescue
            # do nothing
          end
        else
          plan_name = "£#{self.amount.cents/100}"
          find_or_create_plan(self.amount.cents, Settings.subscription_interval, plan_name, merchant_access_token)
          
          # On donations with Gift Aid activated, Makerble should receive 5% of the original donation.
          # On donations without Gift Aid activated, Makerble should receive only 4% of the original donation.
          app_fee_percent = 5
          subscription_projects.active.each do |subscription_project|
            unless subscription_project.gift_aid
              subscription_project_percent = (subscription_project.amount_pennies / amount.fractional.to_f) * 100
              app_fee_percent -= 1/5.to_f * (subscription_project_percent / 100.to_f) * 5
            end
          end
          app_fee_percent = nil if app_fee_percent < 1

          response = merchant_customer.update_subscription(plan: plan_name, application_fee_percent: app_fee_percent.to_i)
          self.application_fee_percent = app_fee_percent.to_i
          self.stripe_subscription_status = response['status']
          self.save
        end
      end
    end
  end

  def find_or_create_plan(amount, interval, plan_name, merchant_access_token)
    begin
      Stripe::Plan.retrieve(plan_name, merchant_access_token)
    rescue Stripe::InvalidRequestError => e
      Stripe::Plan.create({
        amount: amount,
        interval: interval,
        name: plan_name,
        currency: 'gbp',
        id: plan_name
      }, merchant_access_token)
    end
  end
end
