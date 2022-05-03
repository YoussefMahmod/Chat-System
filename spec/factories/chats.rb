FactoryBot.define do
  factory :chat do
      chat_number { 99 }
      app_token_fk { SecureRandom.uuid }
      messages_count { 0 }
  end
end

