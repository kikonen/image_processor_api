# frozen_string_literal: true

class TestsController < ApplicationController

  def token
    jwt_token = Token.create_user_token(params[:id])

    render json: { token: jwt_token }
  end

  def system_token
    jwt_token = Token.create_system_token

    render json: { token: jwt_token }
  end

  def routes
    data = `rails routes`
    render plain: data
  end

  def require_authorization
    # NOTE KI temp solution due to fake_token
#    super unless Util::DEV_ENV
  end
end
