require 'bunny'

class ApplicationDeleteWorker
  include Sneakers::Worker
  from_queue 'application.delete'

  def work(message)
    data = JSON.parse(message)
    Rails.logger.debug "Object: #{data.inspect}"

    application = Application.find_by(token: data["token"])
    Rails.logger.debug "Application: #{application.inspect}"

    if application
        application.chats.destroy_all
        application.destroy
        ack!
    else
      reject!
    end
  end
end
