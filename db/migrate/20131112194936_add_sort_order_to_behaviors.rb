class AddSortOrderToBehaviors < ActiveRecord::Migration[4.2]
  def change
    add_column :behaviors, :behavior_order, :integer
  end
end
