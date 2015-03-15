class CharityJoinRequest < ActiveRecord::Base
  include Requestable

  belongs_to :user
  belongs_to :charity
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  attr_accessible :admin, :message, :status, :user, :charity, :user_id, :charity_id

  validates :status, inclusion: { in: JoinRequestStatus.all }
  validates :user, :charity, :status, presence: true
  validates_length_of :message, maximum: 300

  def add_member_to_charity
    charity.editors << user
  end
end
