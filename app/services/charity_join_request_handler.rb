class CharityJoinRequestHandler
  def initialize(charity_join_request, admin=nil)
    @charity_join_request = charity_join_request
    @admin = admin
  end

  def create
    required_attributes = @charity_join_request.attributes.slice("user_id", "charity_id", "message")
    CharityJoinRequest.create required_attributes
  end

  def approve
    if @charity_join_request.make_approved
      @charity_join_request.admin = @admin
      @charity_join_request.add_member_to_charity
      @charity_join_request.save
    end
  end

  def reject
    if @charity_join_request.make_rejected
      @charity_join_request.admin = @admin
      @charity_join_request.save
    end
  end

  private
  attr_reader :charity_join_request, :admin
end
