# frozen_string_literal: true

class TestsController < ActionController::Base

  def token
    secret = Secret['JWT_KEY']

    data = {
      user: 'xxx',
      expire: 1.hour.from_now,
    }
    jwt_token = JWT.encode(data, secret)

    render plain: jwt_token
  end
end
