namespace :rabbitmq do
  desc "Setup routing"
  task :setup => :environment do
    require "bunny"
    conn = Bunny.new(:host => ENV['RABBITMQ_HOST'] || 'localhost')
    conn.start

    ch = conn.create_channel

    # get or create exchange
    x = ch.fanout("app.messages")
    y = ch.fanout("app.chats")

    # get or create queue (note the durable setting)
    message_q = ch.queue("app.messages", durable: true)
    chat_q = ch.queue("app.chats", durable: true)

    # bind queue to exchange
    message_q.bind(x)
    chat_q.bind(y)

    conn.close
  end
end