class Message < ApplicationRecord
  belongs_to :room, inverse_of: :messages
  belongs_to :user

  validates :message_text, presence: true, length: { minimum: 1, maximum: 250 }
end
