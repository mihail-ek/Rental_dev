namespace :update do
  task "projects" => :environment do
    all_projects = YAML.load_file "data/projects.yml"
    all_projects.each do |project_data|
      project = Project.find_or_create_by_name project_data['name']
      project.charity = Charity.find_or_create_by_name project_data['charity']
      project.cause = Cause.find_or_create_by_name project_data['cause']
      project.save
    end

    puts 'The list of projects were updated'
  end
end
