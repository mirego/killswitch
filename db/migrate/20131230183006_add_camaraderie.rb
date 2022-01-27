class AddCamaraderie < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.references :user
      t.references :organization
      t.string :membership_type

      t.timestamps
    end

    add_index "memberships", ["organization_id", "membership_type"], name: "index_memberships_on_organization_id_and_membership_type"
    add_index "memberships", ["organization_id", "user_id", "membership_type"], name: "index_memberships_on_everything", unique: true
    add_index "memberships", ["organization_id", "user_id"], name: "index_memberships_on_organization_id_and_user_id"
    add_index "memberships", ["organization_id"], name: "index_memberships_on_organization_id"
    add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"
  end

  def down
    drop_table :memberships
  end
end
