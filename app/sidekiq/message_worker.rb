class MessageWorker
  include Sidekiq::Worker

  def perform(message_attributes)
    message = Message.new(message_attributes)
    message.save
  end
end
