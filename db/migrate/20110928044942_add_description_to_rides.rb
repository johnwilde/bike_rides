class AddDescriptionToRides < ActiveRecord::Migration
  def change
    add_column :rides, :description, :text
  end
end
