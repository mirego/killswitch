class AddLastSeenAtToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :last_seen_at, :datetime
    add_index :projects, :last_seen_at
  end
end
