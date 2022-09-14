class RenameBehaviorVersionToVersionNumber < ActiveRecord::Migration[4.2]
  def change
    rename_column :behaviors, :version, :version_number
  end
end
