require 'spec_helper'

describe Users::RegistrationsController do
  describe '#create' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context 'params[:redirect_to_path] is defined' do
      it 'assigns @redirect_to_path' do
        post :create, { redirect_to_path: 'some/path' }

        expect(assigns(:redirect_to_path)).to be
      end

      it 'redirects to @redirect_to_path' do
        path = 'some/path'
        user_attributes = attributes_for :user
        post :create, { redirect_to_path: path, user: user_attributes }

        expect(response).to redirect_to path
      end
    end
  end
end
