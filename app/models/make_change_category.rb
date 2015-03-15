class MakeChangeCategory < ActiveRecord::Base
  has_many :makes
  has_many :changes
  attr_accessible :name, :make_ids, :change_ids
end
