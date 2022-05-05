class Application < ApplicationRecord
  # associations
  has_many :chats, :foreign_key => :app_token_fk, :primary_key => :app_token, :class_name => "Chat", dependent: :destroy
  has_many :messages, :foreign_key => :app_token_fk, :primary_key => :app_token, :class_name => "Message", dependent: :destroy

  #validations
  validates :app_token, presence: true, uniqueness: true, allow_nil: false
  validates_format_of :app_token, :with => /\A[A-Za-z\d]([-\w]{,498}[A-Za-z\d])?\Z/i
  validates :app_name, presence: true, uniqueness: true, allow_nil: false
  validates :app_name, length: { minimum: 1, maximum: 255 }
  

  # get apps which not updated in the last 30 minutes and update it's chat_count to the current number of chat in the app
  def self.update_chats_counter
    apps = Application.where("updated_at <= ?", Time.now - 30.minutes)
    apps.each do |app|
      app.chats_count = app.chats.count
      app.save
    end
  end

end
