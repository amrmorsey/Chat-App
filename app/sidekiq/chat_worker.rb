class ChatWorker
  include Sidekiq::Worker

  def perform(chat_attributes)
    chat = Chat.new(chat_attributes)
    chat.save
  end
end
