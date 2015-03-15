module ProjectsHelper
  def present_project_field(project, field)
    if field.instance_of? Paperclip::Attachment
      tag :img, src: field.url, width: "100px", height: "100px" if field.file?
    elsif field.instance_of? PastExperiencePhoto
      present_project_field(project, field.photo)
    elsif field.instance_of? WelcomeMessage
      content_tag(:div, field.headline) + present_project_field(project, field.image) + content_tag(:div, field.text)
    elsif field.instance_of? Faq
      content_tag(:div, content_tag(:b, "Q: ") + field.question) + content_tag(:div, content_tag(:b, "A: ") + field.answer)
    elsif field.instance_of? Array
      field.map { |f| present_project_field(project, f) }.join "<br>"
    else
      field.to_s
    end
  end
end
