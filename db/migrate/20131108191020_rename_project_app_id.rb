class RenameProjectAppId < ActiveRecord::Migration[4.2]
  def change
    rename_column :projects, :app_id, :application_id
  end
end
