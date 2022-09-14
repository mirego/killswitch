class AddOrganizationCacheCounters < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :memberships_count, :integer, default: 0
    add_column :organizations, :applications_count, :integer, default: 0
  end
end
