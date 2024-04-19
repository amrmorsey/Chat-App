class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  validates :number, presence: false, uniqueness: { scope: :application_id }

  before_create :set_chat_number

  def set_chat_number
    last_chat_number = application.chats.maximum(:number) || 0
    self.number = last_chat_number + 1
  end

end