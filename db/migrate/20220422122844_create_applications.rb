class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :app_token, index: true, null: false, unique: true
      t.string :app_name, null: false
      t.integer :chats_count, null: false, default: 0

      t.timestamps
    end
  end
end
