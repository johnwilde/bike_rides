class AddTableIdToRides < ActiveRecord::Migration
  def change
    add_column :rides, :google_table_id, :text
  end
end
