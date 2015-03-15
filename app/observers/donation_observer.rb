class DonationObserver < ActiveRecord::Observer
  def after_save(donation)
    if donation.refunded_changed? && donation.refunded
      if true # success
        merchant_access_token = donation.charity.stripe_merchant.access_token
        charge = Stripe::Charge.retrieve(donation.stripe_charge_id, merchant_access_token)
        if charge['refunded'] == false
          begin
            charge.refund
          rescue
            # do nothing
          end
        end
      else
        donation.refunded = false
      end
    end
  end
end
