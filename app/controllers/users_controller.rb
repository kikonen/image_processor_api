# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = fetch_request_users
              .order(created_at: :desc)

    render json: users.to_json
  end

  def show
    user = fetch_request_user

    render json: user.to_json
  end

  def create
    if current_user.normal_user?
      render json: { message: "no access" }, status: :forbidden
      return
    end

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
    fetch_request_users
      .where(id: params[:id])
      .first
  end

  def fetch_request_users
    if current_user.normal_user?
      User.where(id: current_user.id)
    else
      User
    end
  end
end
