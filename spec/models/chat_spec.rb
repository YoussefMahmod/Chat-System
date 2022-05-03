require 'rails_helper'

RSpec.describe Chat, type: :model do
  
  # association tests
  # ensure that each chat belong to a single app
  it { should belong_to(:application) }
  # ensure that each chat have many messages
  it { should have_many(:messages) }

  # validation tests
  subject { 
    app = FactoryBot.create(:application)
    chat = FactoryBot.build(:chat, app_token_fk: app.app_token, chat_number: 99, messages_count: 0)
  }

  # ensure that chat_number is present before saving
  it { should validate_presence_of(:chat_number) }
  # ensure that chat_number is unique
  it { should validate_uniqueness_of(:chat_number)}
  # ensure that chat_number is an integer
  it { should validate_numericality_of(:chat_number).only_integer }
  # ensure that chat_number is greater than 0
  it { should validate_numericality_of(:chat_number).is_greater_than(0) }

  # ensure that app_token is present before saving
  it { should validate_presence_of(:app_token_fk) }
  # ensure that app_token is unique
  it { should validate_uniqueness_of(:app_token_fk) }
  
  # ensure that messages_count is present before saving
  it { should validate_presence_of(:messages_count) }
  # ensure that messages_count is an integer
  it { should validate_numericality_of(:messages_count).only_integer }
  # ensure that messages_count is greater than or equal to 0
  it { should validate_numericality_of(:messages_count).is_greater_than_or_equal_to(0) }
  
end
