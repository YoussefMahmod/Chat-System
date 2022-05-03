
class Publisher
  # In order to publish message we need a exchange name.
  # Note that RabbitMQ does not care about the payload -
  # we will be using JSON-encoded strings
  def self.publish(exchange, message = {})
    @@connection ||= $bunny.tap do |c|
      c.start
    end
    @@channel ||= @@connection.create_channel
    @@fanout ||= @@channel.fanout("app.#{exchange}")
    @@queue ||= @@channel.queue("app.#{exchange}", durable: true).tap do |q|
      q.bind("app.#{exchange}")
    end
    # and simply publish message
    @@fanout.publish(message.to_json)
  end
end