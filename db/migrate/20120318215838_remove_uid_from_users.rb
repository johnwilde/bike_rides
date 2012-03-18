class RemoveUidFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :uid
  end

  def down
    add_column :users, :uid, :string
  end
end
