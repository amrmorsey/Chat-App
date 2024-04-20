require 'bunny'

class MessageWorker
  include Sneakers::Worker
  from_queue 'message.create'

  def work(message)
    data = JSON.parse(message)
    # Create message
    message = Message.new(data)

    if message.save
      message.__elasticsearch__.index_document
      ack!
    else
      reject!
    end
  end
end
