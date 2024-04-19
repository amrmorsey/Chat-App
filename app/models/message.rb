class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat, counter_cache: true

  validates :number, presence: true, uniqueness: { scope: :chat_id }
  validates :body, presence: true

  before_create :set_message_number

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, analyzer: 'english'
    end
  end

  def set_message_number
    self.number = chat.messages.count + 1
  end

end
