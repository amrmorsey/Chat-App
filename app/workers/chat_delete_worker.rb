require 'bunny'

class ChatDeleteWorker
  include Sneakers::Worker
  from_queue 'chat.delete'

  def work(message)
    data = JSON.parse(message)
    Rails.logger.debug "Object: #{data.inspect}"

    chat = Chat.find_by(number: data["number"], application_id: data["application_id"])
    Rails.logger.debug "Char: #{chat.inspect}"

    if chat
        chat.messages.destroy_all
        chat.destroy
        ack!
    else
      reject!
    end
  end
end
