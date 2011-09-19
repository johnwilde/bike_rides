class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.integer :fusiontable_id

      t.timestamps
    end
  end
end
