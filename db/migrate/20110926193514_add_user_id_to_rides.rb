class AddUserIdToRides < ActiveRecord::Migration
  def change
    add_column :rides, :user_id, :integer
  end
end
