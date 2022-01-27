class AddSortOrderToBehaviors < ActiveRecord::Migration
  def change
    add_column :behaviors, :behavior_order, :integer
  end
end
