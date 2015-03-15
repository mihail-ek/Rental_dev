require 'spec_helper'

describe 'layouts/_header.html.haml' do
  context 'at home page' do
    before(:each) do
      controller.stub(:controller_name).and_return('home')
      controller.stub(:action_name).and_return('index')
    end

    it 'displays the home navigation links' do
      view.stub(:user_signed_in?)

      render

      expect(rendered).to have_text I18n.t('layouts.header.get_started')
      expect(rendered).to have_text I18n.t('layouts.header.how_makerble_works')
    end

    it 'displays the sign in link for signed out users' do
      view.stub(:user_signed_in?).and_return(false)

      render

      expect(rendered).to have_text I18n.t('layouts.header.sign_in')
    end

    it 'displays the top navigation links for signed out users' do
      view.stub(:user_signed_in?).and_return(false)

      render

      expect(rendered).to have_text I18n.t('layouts.header.charity_sign_up')
      expect(rendered).to have_text I18n.t('layouts.header.request_invitation')
    end

    it 'displays the top navigation links for signed in users who are not yet registered as a member of staff at a charity' do
      view.stub(:current_user) { build_stubbed(:user) }
      view.stub(:user_signed_in?).and_return(true)

      render

      expect(rendered).to have_text I18n.t('layouts.header.charity_sign_up')
      expect(rendered).to have_text I18n.t('layouts.header.request_invitation')
    end

    it 'displays the charity dashboard link for signed in users who are members of staff at a charity' do
      charity = create :charity
      view.stub(:current_user) { charity.editors.first }
      view.stub(:user_signed_in?).and_return(true)

      render

      expect(rendered).to have_text I18n.t('layouts.header.charity_dashboard')
    end
  end

  context 'at other pages' do
    it 'displays the shopping cart link for signed in users' do
      view.stub(:user_signed_in?).and_return(true)
      view.stub(:current_user) { build_stubbed(:user) }
      assign(:cart, stub_model(ShoppingCart))

      render

      expect(rendered).to have_css '.basket'
    end

    it 'displays the signed in links for signed in users' do
      view.stub(:user_signed_in?).and_return(true)
      view.stub(:current_user) { build_stubbed(:user) }

      render

      expect(rendered).to have_css 'a[href="/users/sign_out"]'
      expect(rendered).to have_text I18n.t('layouts.header.faqs')
      expect(rendered).to have_text I18n.t('devise.invitations.new.header')
    end

    it 'displays the charity dashboard link for signed in users who are members of staff at a charity' do
      charity = create :charity
      view.stub(:current_user) { charity.editors.first }
      view.stub(:user_signed_in?).and_return(true)

      render

      expect(rendered).to have_text I18n.t('layouts.header.charity_dashboard')
    end

    it 'renders the navigation bar for signed in users' do
      view.stub(:current_user) { build_stubbed(:user) }
      view.stub(:user_signed_in?).and_return(true)

      render

      expect(rendered).to have_text I18n.t('layouts.header.help_make_change')
      expect(rendered).to have_css '#search-field'
      expect(rendered).to have_css '.user-box'
    end

    it 'displays the top navigation links for signed out users' do
      view.stub(:user_signed_in?).and_return(false)

      render

      expect(rendered).to have_text I18n.t('layouts.header.charity_sign_up')
      expect(rendered).to have_text I18n.t('layouts.header.request_invitation')
    end
  end
end
