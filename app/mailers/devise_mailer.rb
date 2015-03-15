class DeviseMailer < Devise::Mailer
  default :from => "The Makerble team <team@makerble.com>"

  def waiting_list_invitation_instructions(record, opts={})
    @token = record.raw_invitation_token
    devise_mail(record, :waiting_list_invitation_instructions, opts)
  end

  def mass_invitation_instructions(record, opts={})
    @token = record.raw_invitation_token
    devise_mail(record, :mass_invitation_instructions, opts)
  end

  def invitation_to_join_the_waiting_list(email, invited_by)
    @invited_by = invited_by
    mail(to: email, subject: "#{@invited_by.name} invited you to join the waiting list of Makerble")
  end

  def registration_on_the_waiting_list(email)
    mail(to: email, subject: "You've now registered on the waiting list for access to Makerble")
  end
end
