# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = User.all

    render json: users.to_json
  end

  def show
    user = User.find(params[:id])

    render json: user.to_json
  end

  def create
    user_data = params.require(:user).permit(:email)

    user = User.new(user_data)
    user.save!

    render json: user.to_json
  end

  def update
    user_data = params.require(:user).permit(:email)

    user = User.find(params[:id])
    user.update!(user_data)

    render json: user.to_json
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!

    head :no_content
  end

end
