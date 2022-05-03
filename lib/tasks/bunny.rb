namespace :rabbitmq do
  desc "Setup routing"
  task :setup => :environment do
    conn = $bunny
    conn.start

    ch = conn.create_channel

    # get or create exchange
    x = ch.fanout("blog.posts")

    # get or create queue (note the durable setting)
    queue = ch.queue("dashboard.posts", durable: true)

    # bind queue to exchange
    queue.bind("blog.posts")

    conn.close
  end
end