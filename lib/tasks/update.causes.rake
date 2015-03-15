namespace :update do
  task "causes" => :environment do
    causes_list = ['safety', 'health', 'employment', 'accomodation', 'education']

    causes_list.each do |cause_name|
      Cause.find_or_create_by_name cause_name
    end

    puts 'The list of causes were updated'
  end
end
