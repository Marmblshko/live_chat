class Room < ApplicationRecord
  has_many :messages, dependent: :destroy, inverse_of: :room
  has_many :members, dependent: :destroy

  scope :public_rooms, -> {where(is_private: false)}

  validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 250}
end
