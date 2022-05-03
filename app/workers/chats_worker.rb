class ChatsWorker
  include Sneakers::Worker
  # This worker will connect to "app.chats" queue
  from_queue "app.chats"

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  def work(raw_chat)
    ActiveRecord::Base.connection_pool.with_connection do
      chat_json = JSON.parse(raw_chat)
      chat = Chat.new(chat_json)
      if chat.save
        puts chat_json
        ack! # we need to let queue know that message was received and processed
      else
        reject! # reject if message was not saved
      end
    end
  end
end

