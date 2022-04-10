# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = User.all.order(:created_at)

    render json: users.to_json
  end

  def show
    user = fetch_request_user

    render json: user.to_json
  end

  def create
    user_data = params
                  .require(:user)
                  .permit(:email)

    user = User.new(user_data)
    user.save!

    render json: user.to_json
  end

  def update
    user_data = params
                  .require(:user)
                  .permit(:email)

    user = fetch_request_user
    user.update!(user_data)
    user.reload

    render json: user.to_json
  end

  def destroy
    user = fetch_request_user
    user.destroy!

    head :no_content
  end

  def fetch_request_user
    User.find(params[:id])
  end
end
