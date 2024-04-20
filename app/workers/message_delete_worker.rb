require 'bunny'

class MessageDeleteWorker
  include Sneakers::Worker
  from_queue 'message.delete'

  def work(message)
    data = JSON.parse(message)
    Rails.logger.debug "Object: #{data.inspect}"

    message = Message.find_by(number: data["number"], chat_id: data["chat_id"])
    Rails.logger.debug "Char: #{message.inspect}"

    if message
        message.destroy
        ack!
    else
      reject!
    end
  end
end
