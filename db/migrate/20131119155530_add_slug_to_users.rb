class AddSlugToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :slug, :string
  end
end
