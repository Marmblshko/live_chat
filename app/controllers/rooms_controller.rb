class RoomsController < ApplicationController
  before_action :load_rooms, only: %i[index show]
  before_action :set_room, only: %i[show]
  def index
    @room = Room.new
  end

  def show
    @room = Room.new
    @individual_room = Room.find(params[:id])
    render 'index'
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Room was successfully created.' }
      end
    else
      render :new
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def set_room
    @individual_room = Room.find(params[:id])
  end

  def load_rooms
    @rooms = Room.public_rooms
  end
end
