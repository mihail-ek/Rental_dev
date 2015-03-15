class Api::V1::CharitiesController < Api::ApplicationController
  skip_authorize_resource :only => :search
  
  def search
    text = params[:query]

    offset = params[:offset] || 0
    limit = params[:limit] || 10

    a = []
    text.split().each do |word|
      Charity.public.where("LOWER(name) LIKE ?", "%#{word.downcase}%").each do |charity|
        (a.include?(charity)) ? a.insert(0, a.delete(charity)) : a << charity
      end
    end
    @charities = a[offset, limit]

    render :index
  end
end
