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
end
