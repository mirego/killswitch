class RemoveALotOfIndexes < ActiveRecord::Migration
  def up
    remove_index "applications", ["slug", "deleted_at"]
    remove_index "behaviors", ["id", "deleted_at"]
    remove_index "projects", ["application_id"]
    remove_index "projects", ["key"]
    remove_index "projects", ["slug", "deleted_at"]
    remove_index "projects", ["slug"]
    remove_index "users", ["email"]
    remove_index "users", ["slug", "deleted_at"]
  end

  def down
    add_index "applications", ["slug", "deleted_at"], name: "index_applications_on_slug_and_deleted_at", using: :btree
    add_index "behaviors", ["id", "deleted_at"], name: "index_behaviors_on_id_and_deleted_at", using: :btree
    add_index "projects", ["application_id"], name: "index_projects_on_application_id", using: :btree
    add_index "projects", ["key"], name: "index_projects_on_key", using: :btree
    add_index "projects", ["slug", "deleted_at"], name: "index_projects_on_slug_and_deleted_at", using: :btree
    add_index "projects", ["slug"], name: "index_projects_on_slug", using: :btree
    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["slug", "deleted_at"], name: "index_users_on_slug_and_deleted_at", using: :btree
  end
end
