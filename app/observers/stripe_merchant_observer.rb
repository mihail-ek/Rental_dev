class StripeMerchantObserver < ActiveRecord::Observer
  def after_save(stripe_merchant)
    if stripe_merchant.access_token
      charity = stripe_merchant.charity
      if charity && charity.go_cardless_merchant && charity.go_cardless_merchant.access_token && charity.go_cardless_merchant.merchant_id
        charity.is_public = true
        charity.save
      end
    end
  end
end
