class AddDatetimeToBehaviors < ActiveRecord::Migration[4.2]
  def change
    add_column :behaviors, :time_operator, :string
    add_column :behaviors, :time, :datetime
  end
end
