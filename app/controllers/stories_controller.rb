class StoriesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    @story.project = Project.friendly_id.find(params[:story][:project_id])
    respond_to do |format|
      if @story.save
        format.html { redirect_to charities_dashboard_path, notice: 'Story was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to charities_dashboard_path, notice: 'Story was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @story.destroy
    respond_to do |format|
      format.html { redirect_to charities_dashboard_path }
    end
  end
end
