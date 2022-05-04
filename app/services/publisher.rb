
# class Publisher
#   # In order to publish message we need a exchange name.
#   # Note that RabbitMQ does not care about the payload -
#   # we will be using JSON-encoded strings
#   def self.publish(exchange, message = {})
#     @@connection ||= $bunny.tap do |c|
#       c.start
#     end
#     @@channel ||= @@connection.create_channel
#     @@fanout ||= @@channel.fanout("app.#{exchange}")
#     @@queue ||= @@channel.queue("app.#{exchange}", durable: true).tap do |q|
#       q.bind("app.#{exchange}")
#     end
#     # and simply publish message
#     @@fanout.publish(message.to_json)
#   end
# end


# blog/app/services/publisher.rb
class Publisher
  # In order to publish message we need a exchange name.
  # Note that RabbitMQ does not care about the payload -
  # we will be using JSON-encoded strings
  def self.publish(exchange, message = {})
    # grab the fanout exchange
    x = channel.fanout("app.#{exchange}")
    # and simply publish message
    x.publish(message.to_json)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  # We are using default settings here
  # The `Bunny.new(...)` is a place to
  # put any specific RabbitMQ settings
  # like host or port
  def self.connection
    @connection ||= Bunny.new(:host => ENV['RABBITMQ_HOST'] || 'localhost').tap do |c|
      c.start
    end
  end
end
