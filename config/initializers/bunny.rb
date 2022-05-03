$bunny = Bunny.new(:host => ENV['RABBITMQ_HOST'])
Sneakers.configure(:amqp => "amqp://guest:guest@#{ENV['RABBITMQ_HOST']}:5672") 