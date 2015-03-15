class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :handle_mailchimp_campaign
  before_filter :extract_shopping_cart
  before_filter :ensure_domain, if: -> { Rails.env.production? }
  before_filter :set_up_mixpanel, if: -> { Rails.env.production? }
  before_filter :first_time_visiting?, if: -> { Rails.env.production? }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    session.delete(:return_to_url) || super
  end

  def current_user
    @current_user ||= super && User.includes(:charities_as_editor).find(@current_user.id)
  end

  private
    def handle_mailchimp_campaign
      if params[:mail].present? && params[:mail] == "t67sr"
        session[:skip_invitation] = true
        redirect_to root_path
      end
    end

    def set_up_mixpanel
      @tracker = Mixpanel::Tracker.new("62d6730610885a64e82331edffe9afae")
    end

    def first_time_visiting?
      if cookies[:first_time].nil?
        cookies.permanent[:first_time] = 1
        if Rails.env.production?
          @tracker.track(0, '1st visit to website', {
            'Logged in type' => 'No',
            'Existing registration' => 'No',
            'Country' => '',
            'Date of action' => Time.now,
            'Number of website visits' => '0',
            'Number of Makerble logins' => '0',
            'Source' => '',
            'Campaign code' => ''
          })
        end
      end
    end

    def ensure_domain
      if request.env['HTTP_HOST'] != Settings.host
        url = "http://#{Settings.host}#{request.fullpath}"
        redirect_to url # , :status => 301
      end
    end

    def extract_shopping_cart
      cleared = false
      shopping_cart_id = session[:shopping_cart_id]
      @cart = session[:shopping_cart_id] ? ShoppingCart.find(shopping_cart_id) : ShoppingCart.create
      session[:shopping_cart_id] = @cart.id
      @cart_projects = []
      @cart.shopping_cart_items.each do |item|
        if project = Project.where(id: item.item_id).first
          @cart_projects << project
        else
          @cart.clear
          cleared = true
        end
      end
      @cart_charities = []
      unless cleared
        @cart_projects.each { |project| @cart_charities << project.charity }
        @cart_charities.uniq!
      end
    end
end
