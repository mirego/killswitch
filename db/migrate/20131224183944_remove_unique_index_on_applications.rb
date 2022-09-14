class RemoveUniqueIndexOnApplications < ActiveRecord::Migration[4.2]
  def up
    remove_index :applications, :slug
  end

  def down
    add_index :applications, :slug, unique: true
  end
end
