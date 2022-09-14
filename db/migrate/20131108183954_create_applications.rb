class CreateApplications < ActiveRecord::Migration[4.2]
  def change
    create_table :applications do |t|
      t.string :name

      t.timestamps
    end
  end
end
