class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :message_content
      t.integer :message_number, null: false,unique: true
      t.integer :chat_number_fk, null: false, unique: true
      t.string :app_token_fk, null: false, unique: true

      t.timestamps
    end

    add_foreign_key :messages, :applications, column: :app_token_fk, primary_key: :app_token, on_delete: :cascade

    add_foreign_key :messages, :chats, column: :chat_number_fk, primary_key: :chat_number, on_delete: :cascade  
    

    add_index :messages, [:app_token_fk, :chat_number_fk, :message_number], unique: true, name: "index_on_token_chat_number_message_number"
  end
end
