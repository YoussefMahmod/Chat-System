# dashboard/config/initializers/sneakers.rb
Sneakers.configure(:amqp => "amqp://guest:guest@#{ENV['RABBITMQ_HOST']}:5672")
Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy