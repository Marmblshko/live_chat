class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  has_many :messages, dependent: :destroy

  scope :except_current_user, -> (user) { where.not(id: user) }

  after_create_commit { broadcast_append_to 'users' }
end
