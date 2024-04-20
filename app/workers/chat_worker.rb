require 'bunny'

class ChatWorker
  include Sneakers::Worker
  from_queue 'chat.create'

  def work(message)
    data = JSON.parse(message)
    Rails.logger.debug "Object: #{data.inspect}"

    application = Application.find_by(token: data['token'])

    # Create chat
    chat = Chat.new(data)
    Rails.logger.debug "Char: #{chat.inspect}"

    if chat.save

      ack!
    else
      reject!
    end
  end
end
