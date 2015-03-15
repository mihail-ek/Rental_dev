class PendingCharity < Charity
  def self.default_scope
    self.pending
  end

  def self.model_name
    Charity.model_name
  end

  rails_admin do
    label "Pending Charity"
    label_plural "Pending Charities"
    list do
      field :name
      field :number
      field :chv1 do
        pretty_value do
          bindings[:object].chv1? ? bindings[:view].t('yes') : bindings[:view].t('no')
        end
      end
      field :contract do
        pretty_value do
          bindings[:object].contract? ? bindings[:view].t('yes') : bindings[:view].t('no')
        end
      end
      field :paying_in_slip do
        pretty_value do
          bindings[:object].paying_in_slip? ? bindings[:view].t('yes') : bindings[:view].t('no')
        end
      end
      field :hmrc_number
    end
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
