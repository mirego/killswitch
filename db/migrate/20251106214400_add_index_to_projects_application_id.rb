class AddIndexToProjectsApplicationId < ActiveRecord::Migration[8.0]
  def change
    add_index :projects, :application_id
  end
end
