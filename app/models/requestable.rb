module Requestable
  def self.included(base)
    JoinRequestStatus.all.each do |status_name|
      base.class_eval do
        scope status_name.to_sym, -> { base.where(status: status_name) }
      end
    end
  end

  def initialize(*args, &block)
    super
    self.status ||= JoinRequestStatus.default_status
  end

  def self.define_status_methods(status_names)
    status_names.each do |status_name|
      define_method("make_#{status_name}") do
        update_attributes status: status_name
      end

      define_method("#{status_name}?") do
        status == status_name
      end
    end
  end

  define_status_methods(JoinRequestStatus.all)
end
