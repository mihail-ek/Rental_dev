App::Application.routes.draw do
  root :to => "home#index"
  get '/blog', to: redirect('http://www.makeworldwide.blogspot.co.uk', status: 302)

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks",
    sessions: 'users/sessions', invitations: 'users/invitations',
    registrations: 'users/registrations' }
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  mount StripeEvent::Engine => '/stripe/webhooks'

  resources :users
  devise_scope :user do
    post 'invitation/mass' => "users/invitations#mass", as: :mass_invitation
    post 'invitation/generate-link' => "users/invitations#generate_link", as: :generate_invitation_link
    post 'invitation/grant-access' => "waiting_lists#grant_access", as: :grant_access_to_waiting_list
  end
  resources :waiting_lists

  resources :causes
  scope 'charities/dashboard' do
    get 'current-status' => "charities#current_status", as: 'charities_dashboard'
    get 'approvals-new-staff' => "charities#approvals_new_staff", as: 'approvals_new_staff'
  end
  resources :charities, except: :index do
    resources :projects, only: [:new, :create, :edit, :update]
    get "colleagues" => "charities#colleagues", as: :colleagues
    get "projects/:id/trends" => "projects#trends", as: :project_trends
  end

  resources :charity_registrations, only: [:new, :create]
  resources :charity_join_requests, only: [:new, :create]
  resources :stories
  resources :welcome_messages, only: [:show, :destroy]
  resources :projects, only: [:show, :destroy] do
    resources :stories
  end

  # GoCardless
  scope "gocardless" do
    scope "pre-auth" do
      get "index" => "gocardless#pre_auth_index"
      post "submit" => "gocardless#pre_auth_submit"
      get "confirm" => "gocardless#pre_auth_confirm"
    end
    scope "subscription" do
      get "index" => "gocardless#subscription_index"
      post "submit" => "gocardless#subscription_submit"
      get "confirm" => "gocardless#subscription_confirm"
    end
    get "merchant_account_authorization/:state" => "gocardless#merchant_account_authorization", as: :gocardless_merchant_account_authorization
    get "merchant_account_authorization_confirmed" => "gocardless#merchant_account_authorization_confirmed", as: :gocardless_merchant_account_authorization_confirmed
  end
  scope "stripe" do
    # Tests
    get "charges/new" => "stripe#charges_new", as: :new_stripe_charge
    post "charges/create" => "stripe#charges_create", as: :create_stripe_charge
    get "charges/customer" => "stripe#charges_customer", as: :customer_stripe_charge
    get "subscription" => "stripe#subscription", as: :create_stripe_subscription
    # Production
    post "create_charges(/:gift_aid_charity_ids)" => "stripe#create_charges", as: :create_stripe_charges
    post "create_subscriptions(/:gift_aid_charity_ids)" => "stripe#create_subscriptions", as: :create_stripe_subscriptions
    get "merchant_account_authorization/:state" => "stripe#merchant_account_authorization", as: :stripe_merchant_account_authorization
    get "merchant_account_authorization_confirmed" => "stripe#merchant_account_authorization_confirmed", as: :stripe_merchant_account_authorization_confirmed
    get "cancel_subscriptions/:project_id" => "stripe#cancel_subscription", as: :cancel_stripe_subscription
  end

  # _______________ Static pages
  get 'terms-and-conditions' => "pages#terms_and_conditions", as: :terms_and_conditions
  get 'privacy-and-cookies' => "pages#privacy_and_cookies", as: :privacy_and_cookies

  get 'get-started' => "users#waiting_list", as: :waiting_list
  get 'guest/sign-up' => "users#skip_invitation_and_sign_up", as: :skip_invitation_and_sign_up
  post 'guest/create-skipped-invitation' => "users#create_skipped_invitation", as: :create_skipped_invitation

  get "charity-sign-up" => "pages#charity_sign_up", as: :charity_sign_up
  get "personal-sign-up" => "pages#personal_sign_up", as: :personal_sign_up

  get 'change-store-projects' => "pages#change_store_projects", as: 'change_store_projects'
  get 'change-store-projects-category' => "pages#change_store_projects_category"

  get 'project-stage-fundraising' => "pages#project_stage_fundraising"
  get 'project-stage-development-impact-completion' => "pages#project_stage_development_impact_completion"

  get 'checkout/(:project_id)' => "pages#checkout", as: 'checkout'
  get 'payment' => "pages#payment", as: 'payment'

  get 'me' => "pages#me"

  get 'charity-or-bundle-home' => "pages#charity_or_bundle_home", as: 'charity_or_bundle_home'
  get 'charity-or-bundle-updates' => "pages#charity_or_bundle_updates"

  get 'dashboard' => "pages#dashboard"

  get 'received-invitation' => "pages#received_invitation"

  get 'my-home' => "pages#my_home", as: 'my_home'

  get 'causes-preferences-causes' => "pages#causes_preferences_causes", as: 'causes_preferences_causes'
  get 'causes-preferences-places' => "pages#causes_preferences_places"
  get 'causes-preferences-interests' => "pages#causes_preferences_interests", as: 'causes_preferences_interests'
  get 'causes-preferences-collect' => "pages#collect", as: 'causes_preferences_collect'

  get 'defaultsite' => "pages#defaultsite" # 1and1 redirection (301)

  # API
  namespace :api, format: :json do
    namespace :v1 do
      resources :users do
        collection do
          get :search
          get :me
          get :facebookconnect
          # follow
          get :is_following
          post :follow
          post :unfollow
          # cart
          get :cart_projects
          get :cart_add
          get :cart_remove
          get :cart_clear
          get :cart_total
          # likes
          get :like_an_update
          get :unlike_an_update
          # other
          get :update_causes
          get :get_places
          get :update_places
          get :update_intelligent_matching
        end
      end
      resources :causes do
        collection do
          get :search
        end
      end
      resources :lifestyle_checkouts
      resources :charities do
        collection do
          get :search
        end
      end
      resources :charity_join_requests do
        collection do
          post :approve
          post :reject
          get :pending
        end
      end
      resources :projects do
        collection do
          get :search
          get :suggested
          get :selected
        end
      end
      resources :faqs
      resources :comments
    end
  end
end
