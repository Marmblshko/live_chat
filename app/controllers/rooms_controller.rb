class RoomsController < ApplicationController
  before_action :set_users, only: %i[index show]
  before_action :load_rooms, only: %i[index show]
  before_action :set_room, only: %i[show]
  before_action :authenticate_user!, only: %i[create]

  def index
    @room = Room.new
  end

  def show
    @room = Room.new
    @message = Message.new(room: @room)
    @messages = @individual_room.messages
    render 'index'
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append(@room, partial: 'room', locals: { room: @room })}
        format.html { redirect_to root_path, notice: 'Room was successfully created.' }
      end
    else
      render partial: 'rooms/form', status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def set_room
    @individual_room = Room.includes(:messages).find(params[:id])
  end

  def set_users
    @users = User.except_current_user(current_user)
  end

  def load_rooms
    @rooms = Room.public_rooms
  end
end
