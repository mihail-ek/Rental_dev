module Utilities
  def create_visitor
    @visitor ||= FactoryGirl.attributes_for :user
  end

  def find_user
    @user ||= User.first conditions: {:email => @visitor[:email]}
  end

  def create_unconfirmed_user
    create_visitor
    delete_user
    sign_up
    visit '/users/sign_out'
  end

  def create_user
    create_visitor
    delete_user
    @user = FactoryGirl.create(:user, email: @visitor[:email])
  end

  def create_admin
    create_user
    @user.add_role :admin
  end

  def delete_user
    @user ||= User.first conditions: {:email => @visitor[:email]}
    @user.destroy unless @user.nil?
  end

  def sign_up
    visit new_user_registration_path
    fill_in_sign_up_form(@visitor)
    find_user
  end

  def sign_in(user)
    visit '/users/sign_in'
    fill_in_sign_in_form(user)
  end
end

World(Utilities)
