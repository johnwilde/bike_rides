class AddUseMetricUnitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :use_metric_units, :boolean
  end
end
