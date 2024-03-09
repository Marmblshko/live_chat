class Room < ApplicationRecord
  scope :public_rooms, -> {where(is_private: false)}

  validates :name, presence: true, uniqueness: true, length: {minimum: 1, maximum: 250}
end
