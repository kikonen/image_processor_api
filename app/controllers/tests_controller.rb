# frozen_string_literal: true

class TestsController < ActionController::API

  def token
    secret = Secret['JWT_KEY']

    data = {
      user: 'xxx',
      exp: AuthorizationSupport::TOKEN_EXPIRE.from_now.to_i,
    }
    jwt_token = JWT.encode(data, secret)

    render plain: jwt_token
  end
end
