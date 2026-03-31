class AddIndexToApplicationsOrganizationId < ActiveRecord::Migration[8.0]
  def change
    add_index :applications, :organization_id
  end
end
