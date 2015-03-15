class PagesController < ApplicationController
  skip_filter :authenticate_user!, only: [:terms_and_conditions, :privacy_and_cookies, :charity_sign_up, :personal_sign_up]

  def my_home
    redirect_to root_path unless user_signed_in?
    @user = current_user
    @welcome_messages = []
    @user.subscriptions.where(created_at: 2.minutes.ago..Time.now).each do |subscription|
      subscription.projects.each do |project|
        if project.welcome_messages.any?
          @welcome_messages << project.welcome_messages.first
        end
      end
    end
    begin
      redirect_to :back unless user_signed_in?
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end

  def defaultsite
    redirect_to root_path # 1and1 redirection (301)
  end

  def checkout
    project = Project.find(params[:project_id]) if params[:project_id].present?
    if project
      @cart.add(project, 0)
    end

    if @cart.shopping_cart_items.empty?
      redirect_to causes_preferences_collect_path, notice: "Your basket is empty."
    end
  end

  def payment
    redirect_to checkout_path
  end

  def personal_sign_up
    if current_user
      redirect_to new_charity_registration_path
    end
  end
end
