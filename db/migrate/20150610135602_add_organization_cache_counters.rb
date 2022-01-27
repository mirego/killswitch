class AddOrganizationCacheCounters < ActiveRecord::Migration
  def change
    add_column :organizations, :memberships_count, :integer, default: 0
    add_column :organizations, :applications_count, :integer, default: 0
  end
end
