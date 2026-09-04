class CreateProjectActivityDailies < ActiveRecord::Migration[8.0]
  def change
    create_table :project_activity_dailies do |t|
      t.references :project, null: false, foreign_key: true
      t.date :date, null: false
      t.bigint :request_count, null: false, default: 0

      t.timestamps
    end

    add_index :project_activity_dailies, [:project_id, :date], unique: true
    add_index :project_activity_dailies, :date
  end
end
