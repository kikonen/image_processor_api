# frozen_string_literal: true

class TestsController < ApplicationController

  def token
    secret = Secret['JWT_KEY']

    user = User.find(params[:id])

    data = {
      user: user.id,
      exp: AuthorizationSupport::TOKEN_EXPIRE.from_now.to_i,
    }
    jwt_token = JWT.encode(data, secret)

    render json: { token: jwt_token }
  end

  def system_token
    secret = Secret['JWT_KEY']

    data = {
      system: true,
      exp: AuthorizationSupport::TOKEN_EXPIRE.from_now.to_i,
    }
    jwt_token = JWT.encode(data, secret)

    render json: { token: jwt_token }
  end

  def routes
    data = `rails routes`
    render plain: data
  end

  def require_authorization
    super unless Util::DEV_ENV
  end
end
