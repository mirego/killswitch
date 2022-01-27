class AddDatetimeToBehaviors < ActiveRecord::Migration
  def change
    add_column :behaviors, :time_operator, :string
    add_column :behaviors, :time, :datetime
  end
end
