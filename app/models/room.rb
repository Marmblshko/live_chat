class Room < ApplicationRecord
  has_many :messages, dependent: :destroy, inverse_of: :room
  has_many :members, dependent: :destroy

  scope :public_rooms, -> {where(is_private: false)}

  validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 250}

  after_create_commit { broadcast_if_public }

  def broadcast_if_public
    broadcast_append_to "rooms" unless self.is_private
  end

  def self.create_private_room(users, room_name)
    individual_room = Room.create(name: room_name, is_private: true)
    users.each { |user| Member.create(user_id: user.id, room_id: individual_room.id) }
    individual_room
  end
end
