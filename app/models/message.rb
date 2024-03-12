class Message < ApplicationRecord
  belongs_to :room, inverse_of: :messages
  belongs_to :user

  validates :message_text, presence: true, length: { minimum: 1, maximum: 250 }

  after_create_commit :broadcast_to_room
  before_create :confirm_participant

  private

  def broadcast_to_room
    broadcast_append_to(room) if room
  end

  def confirm_participant
    return unless room&.is_private
    throw :abort unless is_member?
  end

  def is_member?
    Member.exists?(user_id: user.id, room_id: room.id)
  end
end
