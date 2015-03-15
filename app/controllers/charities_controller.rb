class CharitiesController < ApplicationController
  before_filter :authenticate_user!, except: :show
  before_filter :current_status_logic, only: [:current_status, :approvals_new_staff]
  load_and_authorize_resource except: [:current_status, :approvals_new_staff, :colleagues]

  def show
    @is_following = user_signed_in? ? @charity.followed_by?(current_user) : false
  end

  def new
    @charity.number ||= flash[:charity_number] if flash[:charity_number]
  end

  def create
    @charity.add_leader current_user
    respond_to do |format|
      if @charity.save
        format.html { redirect_to new_charity_project_path(@charity), notice: I18n.t('layouts.flash_messages.charity_created') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @charity.update_attributes(params[:charity])
        @charity.editor_ids = params[:charity][:editor_ids].split(',') if params[:charity][:editor_ids].present?
        @charity.reporter_ids = params[:charity][:reporter_ids].split(',') if params[:charity][:reporter_ids].present?
        @charity.save
        format.html { redirect_to charities_dashboard_path }
      else
        format.html { render action: "new" }
      end
    end
  end

  def colleagues
    @charity = current_user.charities.first
    authorize! :update, @charity if @charity
  end

  private

  def current_status_logic
    number_of_projects_and_charities_to_manage = current_user.charities_as_editor.count +
                                                 current_user.charities_as_reporter.count +
                                                 current_user.projects_as_editor.count +
                                                 current_user.projects_as_reporter.count

    if number_of_projects_and_charities_to_manage == 1
      if current_user.charities_as_editor.count == 1 || current_user.charities_as_reporter.count == 1
        @charity = current_user.charities.first
        @project = current_user.projects_as_colleague.first unless @charity
      end
    end

    if params[:charity_id]
      @charity = Charity.find(params[:charity_id])
    elsif params[:project_id]
      @project = Project.find(params[:project_id])
    end

    @display_menu = number_of_projects_and_charities_to_manage > 1 && @charity.nil? && @project.nil?

    if @charity
      authorize! :dashboard, @charity

      # staff at related projects
      @staff = []
      @charity.causes.each do |cause|
        if project = cause.projects.offset(rand(Project.count)).first
          @staff << project.leader if project.leader && project.charity != @charity && project.leader != current_user
          @staff.uniq!
        end
      end
      if @staff.count < 10
        (10 - @staff.count).times do
          if project = Project.offset(rand(Project.count)).first
            @staff << project.leader if project.leader && project.charity != @charity && project.leader != current_user
          end
        end
      end
      @staff.uniq!
      # .staff at related projects
    end

    if @project
      authorize! :dashboard, @project
    end
  end
end
