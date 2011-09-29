class AddPrivatedescriptionFieldToRide < ActiveRecord::Migration
  def change
    add_column :rides, :private_description, :text
  end
end
