class CreateBehaviors < ActiveRecord::Migration
  def change
    create_table :behaviors do |t|
      t.references :project
      t.string :version
      t.string :version_operator
      t.string :language
      t.json :data, default: '{}'

      t.timestamps
    end
  end
end
