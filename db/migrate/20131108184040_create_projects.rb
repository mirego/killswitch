class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :app, index: true

      t.timestamps
    end
  end
end
