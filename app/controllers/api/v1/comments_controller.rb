class Api::V1::CommentsController < Api::ApplicationController
  def create
    @comment.user = current_user if user_signed_in?
    if @comment.save
      render :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update_attributes(params[:comment])
      head :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end
end
