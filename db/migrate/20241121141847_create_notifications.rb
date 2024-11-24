class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :message, null: false
      t.string :title, null: false
      t.boolean :viewed, default: false
      t.integer :notification_type, default: 0 # Enum for types
      t.integer :user_id, null: false
      t.timestamps
    end
    add_foreign_key :notifications, :users, on_delete: :cascade
    add_index :notifications, :user_id
  end
end
