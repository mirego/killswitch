class AddIndexToBehaviorsProjectId < ActiveRecord::Migration[8.0]
  def change
    add_index :behaviors, :project_id
  end
end
