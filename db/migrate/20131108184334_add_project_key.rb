class AddProjectKey < ActiveRecord::Migration
  def change
    add_column :projects, :key, :string
    add_index :projects, :key
  end
end
