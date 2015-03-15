class Api::V1::ProjectsController < Api::ApplicationController
  skip_authorize_resource :only => [:search, :suggested, :selected]

  def search
    text = params[:query]

    offset = params[:offset] || 0
    limit = params[:limit] || 10

    a = []
    text.split().each do |word|
      Project.public.where("LOWER(projects.name) LIKE ?", "%#{word.downcase}%").each do |project|
        (a.include?(project)) ? a.insert(0, a.delete(project)) : a << project
      end
    end
    @projects = a[offset, limit]

    render :index
  end

  def suggested
    @project = if !params[:project_id].present? || params[:project_id] == '0'
                 if user_signed_in?
                   current_user.suggested_project
                 else
                   Project.public.unfunded.offset(rand(Project.public.unfunded.count))[0]
                 end
               else
                 Project.public.unfunded.find(params[:project_id])
               end
    if @project
      render :suggested
    else
      render json: 'ok'
    end
  end

  def selected
    @projects = []
    @cart.shopping_cart_items.each { |item| @projects << Project.public.unfunded.find(item.item_id) }
    render :index
  end
end
