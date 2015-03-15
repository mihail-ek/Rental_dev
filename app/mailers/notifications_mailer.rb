class NotificationsMailer < ActionMailer::Base
  default :from => "The Makerble team <notification@makerble.com>"
  layout 'mailer'

  def added_new_colleague_to_a_charity user, charity
    @user = user
    is_editor = charity.editors.include?(user)
    is_reporter = charity.reporters.include?(user)
    colleague_type = is_editor ? 'an editor' : 'a reporter'
    subject = "You have been added as #{colleague_type}."
    @body = "You have been added as #{colleague_type} to the charity '#{charity.name}' on Makerble.com."

    mail(to: user.email, subject: subject)
  end

  def added_new_colleague_to_a_project user, project
    @user = user
    is_editor = project.editors.include?(user)
    is_reporter = project.reporters.include?(user)
    colleague_type = is_editor ? 'an editor' : 'a reporter'
    subject = "You have been added as #{colleague_type}."
    @body = "You have been added as #{colleague_type} to the project '#{project.name}' on Makerble.com."

    mail(to: user.email, subject: subject)
  end
end
