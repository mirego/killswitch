class AddSlugsToApplicationsAndProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :applications, :slug, :string
    add_column :projects, :slug, :string

    add_index :applications, :slug, unique: true
    add_index :projects, :slug
  end
end
