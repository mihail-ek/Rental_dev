class Favorite < ActiveRecord::Base
  belongs_to :user
  attr_accessible :favoritable, :polymorphic => true
end
