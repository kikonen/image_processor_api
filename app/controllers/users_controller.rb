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

  def by_email
    email = params[:email]
    user = fetch_request_users
             .where(email: email)
             .first

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
    user.reload

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

  private

  def fetch_request_user
    fetch_request_users
      .where(id: params[:id])
      .first
  end

  def fetch_request_users
    rel = User.all
    if current_user.normal_user?
      rel = rel.where(id: current_user.id)
    end
    rel
  end
end
