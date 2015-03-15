class CharityJoinRequestMailer < ActionMailer::Base
  default :from => "The Makerble team <notification@makerble.com>"

  def create_request(charity_join_request)
    @requester = charity_join_request.user
    @charity = charity_join_request.charity
    @message = charity_join_request.message
    charity_admin_emails = @charity.editors.pluck(:email).uniq
    subject = I18n.t('mailer.charity_join_request_mailer.create_request.subject')

    mail reply_to: @requester.email, to: charity_admin_emails, subject: subject
  end

  def approve_request_to_requester(charity_join_request)
    @admin = charity_join_request.admin
    @charity = charity_join_request.charity
    @requester = charity_join_request.user
    subject = I18n.t('mailer.charity_join_request_mailer.approve_request_to_requester.subject', charity: @charity.name)

    mail to: @requester.email, subject: subject
  end

  def approve_request_to_charity_admins(charity_join_request)
    @admin = charity_join_request.admin
    @charity = charity_join_request.charity
    @requester = charity_join_request.user
    charity_admin_emails = @charity.editors.pluck(:email).uniq
    charity_admin_emails.delete(@requester.email)
    subject = I18n.t('mailer.charity_join_request_mailer.approve_request_to_charity_admins.subject', charity: @charity.name)

    mail to: charity_admin_emails, subject: subject
  end

  def reject_request_to_requester(charity_join_request)
    @charity = charity_join_request.charity
    @requester = charity_join_request.user
    subject = I18n.t('mailer.charity_join_request_mailer.reject_request_to_requester.subject', charity: @charity.name)

    mail to: @requester.email, subject: subject
  end

end
