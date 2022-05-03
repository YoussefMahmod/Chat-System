FactoryBot.define do
  factory :application do
      app_name { "whatsapp" }
      app_token { SecureRandom.uuid }
  end
end

