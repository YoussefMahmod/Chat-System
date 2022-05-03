require 'rails_helper'

RSpec.describe Message, type: :model do

  # association tests
  # ensure that each message belong to a single chat
  it { should belong_to(:chat) }
  # ensure that each message belong to a application
  it { should belong_to(:application) }

end
