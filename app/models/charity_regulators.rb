class CharityRegulators
  REGULATORS = ["Charity Commission", "OSCR", "None", "Other"]

  def self.all
    REGULATORS
  end

  def self.has?(charity_regulator)
    REGULATORS.include?(charity_regulator)
  end

  REGULATORS.each do |regulator|
    define_singleton_method regulator.parameterize.underscore do
      regulator
    end
  end

  def self.selected_regulator(charity_regulator)
    if has?(charity_regulator)
      charity_regulator
    elsif charity_regulator.present?
      other
    else
      none
    end
  end
end
