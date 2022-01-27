class AddSlugsToApplicationsAndProjects < ActiveRecord::Migration
  def change
    add_column :applications, :slug, :string
    add_column :projects, :slug, :string

    add_index :applications, :slug, unique: true
    add_index :projects, :slug
  end
end
