class AddIndexToProjectsKey < ActiveRecord::Migration[8.0]
  def change
    add_index :projects, :key, unique: true
  end
end
