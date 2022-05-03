class MessagesWorker
  include Sneakers::Worker
  # This worker will connect to "app.messages" queue
  # env is set to nil since by default the actuall queue name would be
  # "app.messages_development"
  from_queue "app.messages"

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  def work(raw_message)
      ActiveRecord::Base.connection_pool.with_connection do
        message_json = JSON.parse(raw_message)
        message = Message.new(message_json)
        if message.save!
          puts message_json
          ack! # we need to let queue know that message was received and processed
        else
          reject! # reject if message was not saved
        end
    end
  end
end