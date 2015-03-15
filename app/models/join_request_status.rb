module JoinRequestStatus
  STATUS ||= [
    'pending',
    'approved',
    'rejected'
  ]
  private_constant :STATUS

  def self.all
    STATUS
  end

  def self.default_status
    STATUS.first
  end
end
