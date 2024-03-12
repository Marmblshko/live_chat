class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @rooms = Room.public_rooms
    @users = User.except_current_user(current_user)
    @room = Room.new
    @message = Message.new

    setup_individual_room

    render "rooms/index"
  end

  private

  def setup_individual_room
    @room_name = generate_room_name(@user, current_user)
    @individual_room = find_or_create_private_room([@user, current_user], @room_name)
    @messages = @individual_room.messages
  end

  def generate_room_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

  def find_or_create_private_room(users, room_name)
    Room.find_by(name: room_name) || Room.create_private_room(users, room_name)
  end
end
