namespace :update do
  task "charities" => :environment do
    all_charities = YAML.load_file "data/charities.yml"
    all_charities.each do |charity|
      charity = Charity.find_or_create_by_name charity['name']
    end

    puts 'The list of charities were updated'
  end
end
