class AddRideToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ride, :integer
  end
end
