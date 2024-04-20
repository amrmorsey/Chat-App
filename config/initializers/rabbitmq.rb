require 'bunny'

# Establish connection
$conn = Bunny.new(
  host: 'rabbitmq',
  port: 5672,
  user: 'admin',
  pass: 'admin'
)
$conn.start

CHAT_CHANNEL = $conn.create_channel
MESSAGE_CHANNEL = $conn.create_channel
APPLICATION_CHANNEL = $conn.create_channel