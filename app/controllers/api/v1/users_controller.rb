class Api::V1::UsersController < Api::ApplicationController
  skip_authorize_resource only: [:search, :facebookconnect, :me,
                                 :follow, :unfollow, :is_following,
                                 :cart_projects, :cart_add, :cart_remove,
                                 :cart_clear, :cart_total,
                                 :update_causes, :get_places,
                                 :update_places, :update_payment_form,
                                 :like_an_update, :unlike_an_update]

  def search
    text = params[:query] || ""

    offset = params[:offset] || 0
    limit = params[:limit] || 10

    a = []
    text.split().each do |word|
      User.where("LOWER(last_name) LIKE ?", "%#{word.downcase}%").each do |user|
        (a.include?(user)) ? a.insert(0, a.delete(user)) : a << user
      end
      User.where("LOWER(first_name) LIKE ?", "%#{word.downcase}%").each do |user|
        (a.include?(user)) ? a.insert(0, a.delete(user)) : a << user
      end
      User.where("LOWER(name) LIKE ?", "%#{word.downcase}%").each do |user|
        (a.include?(user)) ? a.insert(0, a.delete(user)) : a << user
      end
    end
    @users = a[offset, limit]

    render :index
  end

  def facebookconnect
    if @user = User.find_for_facebook_token(params[:facebookToken])
      sign_in @user
      render :me
    else
      render text: {user: "wrong facebook token"}.to_json, status: :unprocessable_entity, layout: 'api_v1'
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :show, @user
  end

  def me
    @user = current_user
    render :me
  end

  # Follow
  def follow
    target = get_following
    current_user.follow(target) if target
    render json: true
  end

  def unfollow
    target = get_following
    current_user.stop_following(target) if target
    render json: true
  end

  def is_following
    target = get_following
    is_following = if target
                     current_user.following?(target)
                   else
                     false
                   end
    render json: is_following
  end

  def get_following
    if params[:charity_id].present?
      Charity.find(params[:charity_id])
    elsif params[:user_id].present?
      User.find(params[:user_id])
    end
  end

  # Cart
  def cart_projects
    get_cart_projects
    render :cart_projects
  end

  def cart_add
    project = Project.find(params[:project_id])
    @cart.add(project, params[:price])
    get_cart_projects
    if Rails.env.production?
      @tracker.track(0, 'Add to basket', {
          'Logged in type' => 'Yes',
          'Existing registration' => 'Yes',
          'Country' => '',
          'Date of action' => Time.now,
          'Number of website visits' => '',
          'Number of Makerble logins' => current_user.sign_in_count,
          'Source' => '',
          'Campaign code' => '',

          'Choice type' => 'Cause',
          'Number of projects added' => '1',
          'Name of projects' => project.name,
          'Logged in type' => 'Yes',
          'Existing registration' => 'Yes'
      })
    end
    render :cart_projects
  end

  def cart_remove
    project = Project.find(params[:project_id])
    @cart.remove(project, params[:quantity])
    get_cart_projects
    render :cart_projects
  end

  def cart_clear
    @cart.clear
    get_cart_projects
    render :cart_projects
  end

  def cart_total
    render json: @cart.total
  end

  def get_cart_projects
    @projects = []
    @cart.shopping_cart_items.each { |item| @projects << Project.find(item.item_id) }
    @projects
  end
  # .Cart

  def update_causes
    conditions = {}
    @causes = if params[:ids].present?
                conditions[:id] = params[:ids].split(',')
                Cause.where(conditions)
              else
                []
              end

    current_user.causes.clear
    @causes.each { |cause| current_user.causes << cause }
    current_user.save

    render json: current_user.causes.to_json(only: [:id, :name])
  end

  def get_places
    render json: current_user.place_list
  end

  def update_places
    current_user.place_list = params[:places]
    current_user.save(validate: false)
    render json: current_user.place_list
  end

  def update_intelligent_matching
    current_user.intelligent_matching = (params[:value] == "true")
    tracker_text = current_user.intelligent_matching ? 'Yes' : 'No'
    if Rails.env.production?
      @tracker.track(0, 'Cause info', {
          'Logged in type' => 'Yes',
          'Existing registration' => 'Yes',
          'Country' => '',
          'Date of action' => Time.now,
          'Number of website visits' => '',
          'Number of Makerble logins' => current_user.sign_in_count,
          'Source' => '',
          'Campaign code' => '',

          'Facebook matching' => tracker_text
      })
    end
    current_user.save(validate: false)
    render json: current_user.intelligent_matching
  end

  def like_an_update
    target = if params[:likable_type] == "Story"
               Story.find(params[:likable_id])
             elsif params[:likable_type] == "Achievement"
               Achievement.find(params[:likable_id])
             end
    current_user.likes(target) if target

    if target
      render json: target.to_json(only: :id)
    else
      render json: false
    end
  end

  def unlike_an_update
    target = if params[:likable_type] == "Story"
               Story.find(params[:likable_id])
             elsif params[:likable_type] == "Achievement"
               Achievement.find(params[:likable_id])
             end

    if target
      target.unliked_by(current_user)
      render json: target.to_json(only: :id)
    else
      render json: false
    end
  end
end
