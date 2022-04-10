# frozen_string_literal: true

module Util
  SYSTEM_TOKEN_EXPIRE = 1.day

  DEV_ENV = Rails.env.development?
  TEST_ENV = Rails.env.test?
  PROD_ENV = Rails.env.production?

  def self.create_system_token
    secret = Secret['JWT_KEY']
    data = {
      system: true,
      exp: AuthorizationSupport::SYSTEM_TOKEN_EXPIRE.from_now.to_i,
    }
    jwt_token = JWT.encode(data, secret)
  end
end
