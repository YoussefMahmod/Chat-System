FactoryBot.define do
  factory :application do
    app_name { Faker::App.unique.name }
    app_token { SecureRandom.uuid }
  end
end

