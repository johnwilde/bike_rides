class AddExtraRawInfoFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :extra_raw_info, :text
  end
end
