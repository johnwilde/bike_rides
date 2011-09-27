class AddIndexToRides < ActiveRecord::Migration
  def change
    add_index :rides, [:user_id, :created_at]
  end
end
