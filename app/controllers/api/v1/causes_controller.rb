class Api::V1::CausesController < Api::ApplicationController
  skip_authorize_resource only: :search
  
  def search
    text = params[:query]

    offset = params[:offset] || 0
    limit = params[:limit] || 10

    a = []
    text.split().each do |word|
      Cause.where("LOWER(name) LIKE ?", "%#{word.downcase}%").each do |cause|
        (a.include?(cause)) ? a.insert(0, a.delete(cause)) : a << cause
      end
    end
    @causes = a[offset, limit]

    render :index
  end
end
