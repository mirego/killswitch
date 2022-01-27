class RenameBehaviorVersionToVersionNumber < ActiveRecord::Migration
  def change
    rename_column :behaviors, :version, :version_number
  end
end
