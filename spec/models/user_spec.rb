require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      expect(user).to be_valid
    end

    it 'is not valid without a username' do
      user = User.new(email: 'test_email@example.com', password: 'qwerty123')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is not valid without a email' do
      user = User.new(username: 'test_name', password: 'qwerty123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid without a password' do
      user = User.new(username: 'test_name',email: 'test_email@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is not valid with a short password' do
      user = User.new(username: 'test_name', email: 'test_email@example.com', password: 'qwe')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it 'is not valid with an invalid email format' do
      user = User.new(username: 'test_name', email: 'is_not_suitable', password: 'qwerty123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'is not valid with a duplicate username' do
      existing_user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      new_user = User.new(username: 'test_name', email: 'test_email_2@example.com', password: 'qwerty123')

      expect(new_user).not_to be_valid
      expect(new_user.errors[:username]).to include('has already been taken')
    end

    it 'is not valid with a duplicate email' do
      existing_user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      new_user = User.new(username: 'test_name2', email: 'test_email@example.com', password: 'qwerty123')

      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many messages with dependent destroy' do
      user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      room = Room.create(name: '1')
      message1 = user.messages.create(message_text: 'Test message', room_id: room.id)
      message2 = user.messages.create(message_text: 'Test message 2', room_id: room.id)

      expect(user.messages).to include(message1, message2)
      expect { user.destroy }.to change { Message.count }.by(-2)
    end
  end

  describe 'scopes' do
    describe '.except_current_user' do
      it 'returns users except the specified user' do
        user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
        other_user = User.create(username: 'test_name2', email: 'test_email_2@example.com', password: 'qwerty123')
        another_user = User.create(username: 'test_name3', email: 'test_email_3@example.com', password: 'qwerty123')
        users = User.except_current_user(user)

        expect(users).to include(other_user, another_user)
        expect(users).not_to include(user)
      end

      it 'returns all users when current user is nil' do
        user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
        users = User.except_current_user(nil)

        expect(users).to include(user)
      end
    end
  end

  describe 'callbacks' do
    describe 'after_create_commit' do
      it 'broadcasts user creation to users channel' do
        user = User.new(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')

        expect { user.save }.to have_broadcasted_to('users')
      end
    end
  end

  describe '#username' do
    it 'returns the username as the display name' do
      user = User.new(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')

      expect(user.username).to eq('test_name')
    end
  end
end