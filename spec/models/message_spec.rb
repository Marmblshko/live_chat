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
end
