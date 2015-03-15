class TopUp < ActiveRecord::Base
  belongs_to :user
  attr_accessible :topupable, :polymorphic => true
end
