class MessagesController < ApplicationController
  before_action :authenticate_user!


  def create
    @message = current_user.messages.create(message_text: message_params[:message_text], room_id: params[:room_id])
  end

  private

  def message_params
    params.require(:message).permit(:message_text, :room_id)
  end

end
