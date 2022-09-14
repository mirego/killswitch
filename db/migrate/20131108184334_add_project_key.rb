class AddProjectKey < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :key, :string
    add_index :projects, :key
  end
end
