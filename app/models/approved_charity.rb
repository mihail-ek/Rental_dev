class ApprovedCharity < Charity
  def self.default_scope
    self.public
  end

  def self.model_name
    Charity.model_name
  end

  rails_admin do
    label "Approved Charity"
    label_plural "Approved Charities"
    edit do
      exclude_fields :slug, :followings, :go_cardless_merchant, :stripe_merchant, :stripe_customers, :subscriptions, :donations
      configure :charity_regulator, :enum do
        def form_value
          bindings[:object].my_charity_regulator
        end

        multiple do
          false
        end

        def render
          bindings[:view].render :partial => "form_enumeration_with_other", :locals => {:field => self, :form => bindings[:form]}
        end
      end
    end
  end
end
