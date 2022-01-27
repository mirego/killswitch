class RenameProjectAppId < ActiveRecord::Migration
  def change
    rename_column :projects, :app_id, :application_id
  end
end
