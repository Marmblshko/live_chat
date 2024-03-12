require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "associations" do
    it "belongs to a room and a user" do
      message = Message.new

      expect(message).to respond_to(:room)
      expect(message).to respond_to(:user)
    end
  end

  describe "validations" do
    it "is invalid without message_text" do
      message = Message.new(message_text: nil)

      expect(message).not_to be_valid
      expect(message.errors[:message_text]).to include("can't be blank")
    end

    it "is invalid if message_text is too short" do
      message = Message.new(message_text: "")

      expect(message).not_to be_valid
      expect(message.errors[:message_text]).to include("is too short (minimum is 1 character)")
    end

    it "is invalid if message_text is too long" do
      message = Message.new(message_text: "a" * 251)

      expect(message).not_to be_valid
      expect(message.errors[:message_text]).to include("is too long (maximum is 250 characters)")
    end
  end

  describe "callbacks" do
    describe "after_create_commit" do
      it "calls broadcast_to_room after creating a message" do
        user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
        room = Room.create(name: "Test Room", is_private: false)
        message = user.messages.build(message_text: 'Test message', room_id: room.id)

        expect(message).to receive(:broadcast_to_room)

        message.save
      end
    end
  end

  describe "private room scenario" do
    it "does not abort creation if room is private and user is a member" do
      user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      room = Room.create(name: "Private Room", is_private: true)
      message = user.messages.build(message_text: 'Test message', room_id: room.id)

      expect { message.save }.not_to raise_error
    end
  end

  describe "private room scenario" do
    it "aborts creation if room is private and user is not a member" do
      user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      room = Room.create(name: "Private Room", is_private: true)
      message = user.messages.build(message_text: 'Test message', room_id: room.id)

      expect { message.save }.not_to change(Message, :count)
    end
  end

  describe "#is_member?" do
    it "returns true if user is a member of the room" do
      user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      room = Room.create(name: "Test Room", is_private: true)
      member = Member.create(user: user, room: room)
      message = user.messages.build(message_text: 'Test message', room_id: room.id)

      expect(message.send(:is_member?)).to be_truthy
    end

    it "returns false if user is not a member of the room" do
      user = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      room = Room.create(name: "Test Room", is_private: true)
      message = Message.new(message_text: "Test message", room: room, user: user)

      expect(message.send(:is_member?)).to be_falsy
    end
  end
end
