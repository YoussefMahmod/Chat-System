require 'rails_helper'

def validate_uuid_format(uuid)
  uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  if uuid_regex.match?(uuid.to_s.downcase) == true
    return true    
  else
    return false
  end

end

RSpec.describe Application, type: :model do
  
  # association tests
  # ensure that each app have many chats (1-m relationship)
  it { should have_many(:chats) }
  # ensure that each app have many messages (1-m relationship)
  it { should have_many(:messages)}

  # validation tests

  subject {FactoryBot.build(:application)}
  # ensure columns app_token, app_name are present before saving
  it { should validate_presence_of(:app_token) }
  it { should validate_presence_of(:app_name) }

  # ensure columns app_token, app_name are unique
  it { should validate_uniqueness_of(:app_token) }
  it { should validate_uniqueness_of(:app_name) }

  # ensure that app_name is a string
  it { should validate_length_of(:app_name).is_at_least(1) }
  it { should validate_length_of(:app_name).is_at_most(255) }
  

end
