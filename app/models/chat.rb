class Chat < ApplicationRecord
  # associations
  belongs_to :application, :foreign_key => :app_token_fk, :primary_key => :app_token, :class_name => "Application"
  has_many :messages, :foreign_key => :chat_number_fk, :primary_key => :chat_number, :class_name => "Message", dependent: :destroy

  # validations
  validates :chat_number, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :app_token_fk, presence: true, allow_nil: false
  validates_format_of :app_token_fk, :with => /\A[A-Za-z\d]([-\w]{,498}[A-Za-z\d])?\Z/i
  validates :messages_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # get chats which not updated in the last 30 minutes and update it's message_count to the current number of messages in the chat
  def self.update_messages_counter
    chats = Chat.where("updated_at <= ?", Time.now - 30.minutes)
    chats.each do |chat|
      chat.messages_count = chat.messages.count
      chat.save
    end
  end

end
