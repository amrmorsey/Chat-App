class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  validates :number, presence: false, uniqueness: { scope: :application_id }

  # before_create :set_chat_number

  def set_chat_number
    application_token = self.application.token
    self.number = $redis.hincrby("chat_numbers", application_token, 1)
  end

end