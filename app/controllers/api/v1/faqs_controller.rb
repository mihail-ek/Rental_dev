class Api::V1::FaqsController < Api::ApplicationController
  def create
    if @faq.save
      render :show, status: :created
    else
      render json: @faq.errors, status: :unprocessable_entity
    end
  end

  def update
    if @faq.update_attributes(params[:faq])
      head :no_content
    else
      render json: @faq.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @faq.destroy
    head :no_content
  end
end
