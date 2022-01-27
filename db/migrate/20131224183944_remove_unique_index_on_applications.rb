class RemoveUniqueIndexOnApplications < ActiveRecord::Migration
  def up
    remove_index :applications, :slug
  end

  def down
    add_index :applications, :slug, unique: true
  end
end
