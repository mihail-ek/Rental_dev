class Api::V1::ShoppingCartsController < Api::ApplicationController
  skip_authorize_resource

  def projects
    projects = @cart.shopping_cart_items
  end

  def add
    project = Project.find(params[:project_id])
    @cart.add(project, params[:price])
    head :no_content
  end

  def remove
    project = Project.find(params[:project_id])
    @cart.remove(project, 1)
    head :no_content
  end

  def clear
    @cart.clear
    head :no_content
  end

  def total
    render json: @cart.total.to_json
  end
end
