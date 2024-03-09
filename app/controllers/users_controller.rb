class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @users = User.except_current_user(current_user)
  end
end
