class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username].downcase)
  end
end
