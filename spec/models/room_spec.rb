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
end
