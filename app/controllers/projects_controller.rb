class ProjectsController < ApplicationController
  before_filter :authenticate_user!, except: :show
  load_resource :charity, only: [:new, :edit, :update]
  load_resource :project, through: :charity, only: [:new, :edit, :update]
  load_resource :project, only: [:show, :destroy]
  authorize_resource except: [:trends, :index]

  respond_to :json, only: [:create, :update]

  def show
    @charity = @project.charity
    @is_subscribed = SubscriptionProject.joins(:subscription).where('subscriptions.user_id' => current_user.id, project_id: @project.id).exists?
  end

  def new
    @project.welcome_messages.build
    @causes = Cause.all
    @makes = Make.all
    @changes = Change.all
  end

  def create
    @charity = Charity.find(params[:charity_id])
    sub_causes_params = params[:project].delete(:cause_sub_causes)
    faqs_params = params[:project].delete(:faqs_attributes)
    @project = Project.new(params[:project].merge({charity_id: @charity.id}))
    @project.add_leader current_user

    ActiveRecord::Base.transaction do
      begin
        manage_sub_causes(sub_causes_params)
        @project.colleague_ids = params[:project][:colleague_ids].split(',') if params[:project][:colleague_ids].present?
        authorize! :update, @project.charity
        @project.save!
        manage_faqs(faqs_params)
        render json: Rabl.render(@project, 'api/v1/projects/show.json', :view_path => 'app/views')
      rescue => e
        render json: project_errors, status: :unprocessable_entity
      end
    end
  end

  def edit
    @causes = Cause.all
    @makes = Make.all
    @changes = Change.all
    @project.welcome_messages.build if @project.welcome_messages.empty?
  end

  def update
    ActiveRecord::Base.transaction do
      begin
        manage_sub_causes
        manage_faqs(params[:project].delete(:faqs_attributes))
        @project.colleague_ids = params[:project][:colleague_ids].split(',') if params[:project][:colleague_ids].present?
        @project.save!
        was_draft = @project.draft
        @project.update_attributes!(params[:project])
        now_is_pending = !@project.draft
        if was_draft && now_is_pending
          ProjectMailer.submit_project_to_requester(@project).deliver
          ProjectMailer.submit_project_to_charity_master_admin(@project).deliver
        end
        render json: Rabl.render(@project, 'api/v1/projects/show.json', :view_path => 'app/views')
      rescue => e
        render json: project_errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to charities_dashboard_path }
    end
  end

  def trends
    @project = Project.find(params[:id])
    authorize! :trends, @project
  end

  private
  def manage_sub_causes(sub_causes_params=nil)
    sub_causes_to_build = []
    sub_causes_to_append = []
    sub_causes_params ||= params[:project].delete(:cause_sub_causes) || {}
    cause_ids = params[:project][:cause_ids] || []

    sub_causes_params.each do |cause_id, sub_cause_list|
      cause_is_selected = cause_ids.include? cause_id
      if cause_is_selected
        sub_causes_split = sub_cause_list[:sub_cause_list].split(",").map(&:strip)
        sub_causes_split.each do |sub_cause_name|
          sub_cause_attributes = { name: sub_cause_name, cause_id: cause_id }
          existing_sub_cause = SubCause.where(sub_cause_attributes).first
          if existing_sub_cause.present?
            sub_causes_to_append.push(existing_sub_cause)
          else
            sub_causes_to_build.push(sub_cause_attributes)
          end
        end
      end
    end

    @project.sub_causes = sub_causes_to_append unless sub_causes_to_append.empty?
    @project.sub_causes.build sub_causes_to_build
  end

  def manage_faqs(faq_params)
    faq_params ||= {}

    faq_params.values.each do |faq_attributes|
      question = faq_attributes[:question]
      if faq_attributes[:_destroy] == '1'
        Faq.destroy faq_attributes[:id]
      elsif question.present?
        answer = faq_attributes[:answer]
        faq = Faq.find_or_create_by_id_and_project_id(faq_attributes[:id], @project.id)
        faq.comments = [Comment.new(text: question, user_id: current_user.id)]
        faq.question.comments = [Comment.new(text: answer, user_id: current_user.id)] if answer.present?
      end
    end
  end

  def project_errors
    errors = @project.errors.messages.keys.zip @project.errors.full_messages
    messages = {
        help: errors.inject([]) { |result, element| result << element.last if @project.help_inputs.include?(element.first); result },
        make: errors.inject([]) { |result, element| result << element.last if @project.make_inputs.include?(element.first); result },
        change: errors.inject([]) { |result, element| result << element.last if @project.change_inputs.include?(element.first); result },
        moreinfo: errors.inject([]) { |result, element| result << element.last if @project.more_info_inputs.include?(element.first); result },
        project: errors.inject([]) { |result, element| result << element.last; result }
    }

    { errors: messages.select {|k,v| v.present?} }
  end
end
