class CreateOrganizations < ActiveRecord::Migration[4.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end

    Organization.create(name: 'Mirego')

    add_column :applications, :organization_id, :integer

    Application.all.each do |application|
      application.update organization: Organization.first
    end
  end
end
