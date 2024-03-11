require 'rails_helper'

RSpec.describe Room, type: :model do
  describe ".public_rooms" do
    it "returns public rooms" do
      public_room = Room.create(name: "Public Room", is_private: false)
      private_room = Room.create(name: "Private Room", is_private: true)

      result = Room.public_rooms

      expect(result).to include(public_room)
      expect(result).not_to include(private_room)
    end
  end

  describe "#name" do
    it "is valid with a unique name and within length limits" do
      room = Room.new(name: "Test Room")
      expect(room).to be_valid
      expect(room.errors[:name]).to be_empty
    end

    it "is invalid without a name" do
      room = Room.new(name: nil)
      expect(room).not_to be_valid
      expect(room.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a non-unique name" do
      existing_room = Room.create(name: "Test Room")
      room = Room.new(name: "Test Room")
      expect(room).not_to be_valid
      expect(room.errors[:name]).to include("has already been taken")
    end

    it "is invalid if the length is less than 1" do
      room = Room.new(name: "")
      expect(room).not_to be_valid
      expect(room.errors[:name]).to include("is too short (minimum is 1 character)")
    end

    it "is invalid if the length is more than 250" do
      room = Room.new(name: "a" * 251)
      expect(room).not_to be_valid
      expect(room.errors[:name]).to include("is too long (maximum is 250 characters)")
    end
  end

  describe "#create_private_room" do
    it "creates a private room and associates users as members" do
      user1 = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      user2 = User.create(username: 'test_name2', email: 'test_email_2@example.com', password: 'qwerty123')

      individual_room = Room.create_private_room([user1, user2], "Private Room")

      expect(individual_room).to be_an_instance_of(Room)
      expect(individual_room.is_private).to be_truthy
      expect(individual_room.name).to eq("Private Room")
      expect(individual_room.members.map(&:user_id)).to contain_exactly(user1.id, user2.id)
    end
  end

  describe "#broadcast_if_public" do
    it "broadcasts to 'rooms' channel for public rooms" do
      public_room = Room.create(name: "Public Room", is_private: false)
      private_room = Room.create(name: "Private Room", is_private: true)

      expect(ActionCable.server).to receive(:broadcast).with("rooms", anything)

      public_room.broadcast_if_public
      private_room.broadcast_if_public
    end
  end

  describe "callbacks" do
    describe "after_create_commit" do
      it "calls broadcast_if_public after creating a room" do
        room = Room.new(name: "New Room", is_private: false)

        expect(room).to receive(:broadcast_if_public)

        room.save
      end
    end
  end

  describe "associations" do
    it "has many messages and members" do
      room = Room.new(name: "Association Room")

      expect(room).to respond_to(:messages)
      expect(room).to respond_to(:members)
    end

    it "destroys associated messages and members when destroyed" do
      user1 = User.create(username: 'test_name', email: 'test_email@example.com', password: 'qwerty123')
      room = Room.create(name: "Destroy Room")
      message = user1.messages.create(message_text: 'Test message', room_id: room.id)
      member = room.members.create(user_id: user1.id)

      expect { room.destroy }.to change { Message.count }.by(-1)
                                                         .and change { Member.count }.by(-1)
    end
  end
end
