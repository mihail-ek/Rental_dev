class GoCardlessMerchantObserver < ActiveRecord::Observer
  def after_save(go_cardless_merchant)
    if go_cardless_merchant.access_token && go_cardless_merchant.merchant_id
      charity = go_cardless_merchant.charity
      if charity && charity.stripe_merchant && charity.stripe_merchant.access_token
        charity.is_public = true
        charity.save
      end
    end
  end
end
