class MonetizeProjectsMake < ActiveRecord::Migration
  def change
    add_money :projects_makes, :cost
  end
end
