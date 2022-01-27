class AddIsSuperAdminToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :super_admin, :boolean, default: false
  end
end
