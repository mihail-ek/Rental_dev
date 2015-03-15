class Users::InvitationsController < Devise::InvitationsController
  def edit
    session[:invitation_token] = params[:invitation_token] if params[:invitation_token].present?
    redirect_to new_user_registration_url
  end

  def generate_link
    if !params[:user].present? || !params[:user][:email].present? || (params[:user][:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?
      redirect_to :back, notice: 'Please make sure that your email address is valid.'
    else
      user = User.invite!(email: params[:user][:email]) do |u|
        u.skip_invitation = true
      end
      redirect_to :back, notice: "Link for #{user.email}: #{accept_invitation_url(user, :invitation_token => user.raw_invitation_token)}"
    end
  end

  def mass
    emails = params[:invitation][:emails_list].split(',').map(&:chomp)
    User.send_mass_invitations(emails)
    redirect_to root_path, notice: 'The invitations are being sent.'
  end

  def create
    if !current_user.has_role?(:admin) && current_user.invitations.count > 2 # TODO check that the invitation count is ok
      WaitingList.create(email: params[:user][:email])
      DeviseMailer.delay.invitation_to_join_the_waiting_list(params[:user][:email], current_user)
      redirect_to :back, notice: 'This email has been added to the waiting list. You have already used your two direct invitations.'
    elsif params[:invitation].present? && params[:invitation][:waiting_list].present? && params[:invitation][:waiting_list] == "1"
      WaitingList.create(email: params[:user][:email])
      DeviseMailer.delay.invitation_to_join_the_waiting_list(params[:user][:email], current_user)
      redirect_to root_path, notice: 'This email has been added to the waiting list.'
    else
      if Rails.env.production?
        @tracker.track(0, 'Advocacy', {
            'Logged in type' => 'Yes',
            'Existing registration' => 'Yes',
            'Country' => '',
            'Date of action' => Time.now,
            'Number of website visits' => '',
            'Number of Makerble logins' => current_user.sign_in_count,
            'Source' => '',
            'Campaign code' => '',

            'Personal invite' => 'Yes',
            'Personal invite number' => 'undefined',
            'Activated Facebook sharing' => current_user.intelligent_matching ? 'Yes' : 'No',
            'Activated Facebook profile' => current_user.facebook_token ? 'Yes' : 'No',
            'Buy a friend a gift voucher' => 'No'
        })
      end
      super
    end
  end

  protected
    def has_invitations_left?
      true # 2 direct invitations and then
    end
end
