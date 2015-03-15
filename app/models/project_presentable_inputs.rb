module ProjectPresentableInputs
  HELP_INPUTS = [:help_statement, :help_description, :beneficiaries, :problem_list, :problem_statistic_list, :help_image, :tag_list, :causes]
  MAKE_INPUTS = [:make_statement, :activities, :projects_makes, :make_image, :method_list, :budget_confirmation]
  CHANGE_INPUTS = [:change_statement, :projects_changes, :change_tag_list, :past_experience, :past_experience_photos]
  MORE_INFO_INPUTS = [:headline, :location, :welcome_messages, :editors, :reporters, :faqs]

  def self.help_inputs
    HELP_INPUTS
  end

  def self.make_inputs
    MAKE_INPUTS
  end

  def self.change_inputs
    CHANGE_INPUTS
  end

  def self.more_info_inputs
    MORE_INFO_INPUTS
  end
end
