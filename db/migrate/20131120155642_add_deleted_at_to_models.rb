class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    add_column :applications, :deleted_at, :datetime
    add_index :applications, [:slug, :deleted_at], name: "index_applications_on_slug_and_deleted_at"

    add_column :projects, :deleted_at, :datetime
    add_index :projects, [:slug, :deleted_at], name: "index_projects_on_slug_and_deleted_at"

    add_column :behaviors, :deleted_at, :datetime
    add_index :behaviors, [:id, :deleted_at], name: "index_behaviors_on_id_and_deleted_at"

    add_column :users, :deleted_at, :datetime
    add_index :users, [:slug, :deleted_at], name: "index_users_on_slug_and_deleted_at"
  end
end
