require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module App
  class Application < Rails::Application

    config.generators do |g|

      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'

      g.view_specs false
      g.helper_specs false
    end

    # For heroku -- http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets
    config.assets.initialize_on_precompile = true

    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end

    config.autoload_paths += %W(#{config.root}/lib)


    config.active_record.observers = :go_cardless_merchant_observer, :stripe_merchant_observer,
      :subscription_project_observer, :donation_observer, :user_observer,
      :charity_observer, :project_observer, :project_donation_observer

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    I18n.enforce_available_locales = true
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.encoding = "utf-8"
    config.filter_parameters += [:password, :password_confirmation]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
