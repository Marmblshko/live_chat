require 'rails_helper'

RSpec.describe Member, type: :model do
  describe "associations" do
    it "belongs to a user and a room" do
      member = Member.new

      expect(member).to respond_to(:user)
      expect(member).to respond_to(:room)
    end
  end

  describe "validations" do
    it "is invalid without a user_id" do
      member = Member.new(room_id: 1)

      expect(member).not_to be_valid
      expect(member.errors[:user]).to include("must exist")
    end

    it "is invalid without a room_id" do
      member = Member.new(user_id: 1)

      expect(member).not_to be_valid
      expect(member.errors[:room]).to include("must exist")
    end
  end
end
