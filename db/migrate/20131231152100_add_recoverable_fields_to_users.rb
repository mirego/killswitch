class AddRecoverableFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
    end
  end
end
