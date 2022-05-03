class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :chat_number, null: false, unique: true, index: true
      t.string  :app_token_fk, null: false, unique: true
      t.integer :messages_count, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :chats, :applications, column: :app_token_fk, primary_key: :app_token, on_delete: :cascade

    add_index :chats, [:app_token_fk, :chat_number], unique: true, name: "index_on_token_chat_number"
  end
end
