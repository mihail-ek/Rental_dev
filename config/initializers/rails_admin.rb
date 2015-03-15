require Rails.root.join('lib', 'rails_admin_approve_project.rb')

module RailsAdmin
  module Config
    module Actions
      class ApproveProject < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      end
    end
  end
end

RailsAdmin.config do |config|
  config.authorize_with :cancan

  config.main_app_name = ['Makerble', 'Admin']
  config.current_user_method { current_user }

  config.yell_for_non_accessible_fields = false

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Role', 'User']

  # Include specific models (exclude the others):
  # config.included_models = ['Role', 'User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]

  RailsAdmin.config do |config|
    config.actions do
      dashboard
      index
      new

      approve_project

      show
      edit
      delete
    end
  end

  ################  Model configuration  ################

  config.model 'Cause' do
    edit do
      include_all_fields
      exclude_fields :created_at, :updated_at
      field :coin do
        help 'The recommended size is 1500x1500'
      end
      field :inactive_coin do
        help 'The recommended size is 1500x1500'
      end
    end
  end
end
