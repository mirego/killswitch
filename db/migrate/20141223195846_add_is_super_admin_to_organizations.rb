class AddIsSuperAdminToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :super_admin, :boolean, default: false
  end
end
