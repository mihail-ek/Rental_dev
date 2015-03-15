class ProjectMailer < ActionMailer::Base
  default :from => "The Makerble team <notification@makerble.com>"
  add_template_helper(ProjectsHelper)

  def submit_project_to_requester(project)
    @project = project
    @requester = project.leader
    subject = I18n.t('mailer.project_mailer.submit_project.subject')

    mail to: @requester.email, subject: subject
  end

  def submit_project_to_charity_master_admin(project)
    @project = project
    subject = I18n.t('mailer.project_mailer.submit_project.subject')

    mail to: ENV['CHARITY_MASTER_ADMIN_EMAIL'], subject: subject
  end
end
