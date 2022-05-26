FactoryBot.define do
  factory :chat do
    chat_number { Faker::Number.unique.number(5) }
    app_token_fk { SecureRandom.uuid }
    messages_count { 0 }
  end
end

