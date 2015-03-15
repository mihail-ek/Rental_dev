source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '3.2.15'

# Databases
gem 'pg'
gem 'sqlite3', group: :development

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'

  # CSS Authoring Framework
  gem 'compass-rails'

  # Haml Coffee templates in the Rails asset pipeline or as Sprockets engine.
  gem 'haml_coffee_assets'
  gem 'execjs'
end

gem "rspec-rails", :group => [:development, :test]
gem 'shoulda-matchers', group: :test
gem "database_cleaner", :group => :test
gem "email_spec", :group => :test
gem "letter_opener", :group => :development
gem "cucumber-rails",:group => :test, :require => false
gem "launchy", :group => :test
gem "capybara", :group => :test
gem "capybara-webkit", group: :test
gem 'selenium-webdriver', group: :test
gem "factory_girl_rails", :group => [:development, :test]
gem "quiet_assets", :group => :development
gem "figaro"
gem 'spring', :group => :development
gem 'spring-commands-rspec', :group => :development
gem 'spring-commands-cucumber', :group => :development

# Better error page for Rails and other Rack apps
gem "better_errors", :group => :development
gem "binding_of_caller", :group => :development # To use Better Errors' advanced features
gem 'pry', :group => :development

# Last version of JQuery in the asset pipeline
gem 'jquery-rails'

# Webserver # http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/
# gem "unicorn", :group => :production
gem 'puma', :group => :production

# Templates
gem "haml-rails"
gem "html2haml", :group => :development

# Front-end framework
gem "bootstrap-sass"

# User authentication
gem "devise", "3.1.1" # uninitialized constant Devise::Models::TokenAuthenticatable

# User authorization
gem "cancan"
gem "rolify", '3.2.0' # https://github.com/EppO/rolify/pull/218 (should be able to not specify the version really soon)

# API templates
gem 'rabl'

# Better forms
gem "simple_form"

# Flexible authentication system utilizing Rack middleware
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

# http://stackoverflow.com/questions/22660147/rails-3-2-17-runtime-error-redirection-forbidden-facebook
gem 'open_uri_redirections'

# Provide an easy-to-use interface for managing your data
gem 'rails_admin'
gem 'kaminari', "~> 0.14.1" # https://github.com/sferik/rails_admin/issues/1828

# A library for generating fake data such as names, addresses, and phone numbers.
gem 'faker'

# Easy file attachment management for ActiveRecord
gem "paperclip"
gem 'aws-sdk', '~> 1.5.7'

# Add GoCardless for payment
gem 'gocardless'

# Add Stripe for payment
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'stripe_event', '0.6.1' # Stripe webhook integration for Rails applications.

# Easily setup and use backbone.js with Rails 3.1 and greater
gem "rails-backbone"

# Gem to access to Facebook graph
gem 'koala'

# Pretty URL’s
gem 'friendly_id'

# Rails plugin to conveniently handle multiple models in a single form.
gem "nested_form"

# Select2 is a jQuery based replacement for select boxes.
gem "select2-rails"

# A tagging plugin that allows for custom tagging along dynamic contexts.
gem 'acts-as-taggable-on'

# Library for dealing with money and currency conversion
gem 'money-rails'

# Dynamic nested forms using jQuery made easy; works with formtastic, simple_form or default forms
gem "cocoon"

# An invitation strategy for devise
gem 'devise_invitable'

# Simple Shopping Cart implementation
gem 'acts_as_shopping_cart', '~> 0.1.6'

# A simple and straightforward settings solution that uses an ERB enabled YAML file and a singleton design pattern.
gem 'settingslogic'

# Makes http fun again!
gem 'httparty'

# Mixpanel: analytics
gem 'mixpanel-ruby'

# A Gem to add Follow functionality for models
gem "acts_as_follower", '~> 0.1.1' # Rails 3.x

# Votable ActiveRecord for Rails
gem 'acts_as_votable', '~> 0.7.1'

# Database based asynchronously priority queue system
gem 'delayed_job_active_record'

# An email validator for Rails 3 and 4.
gem 'email_validator'

# WebSocket client for live notifications
gem 'websocket-rails'
