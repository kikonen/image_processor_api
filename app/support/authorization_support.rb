# frozen_string_literal: true

module AuthorizationSupport
  HEADER_BEARER = 'BEARER'

  def require_authorization
    check_jwt_token
  end

  def check_jwt_token
    jwt = fetch_request_jwt
  end

  def fetch_request_jwt
    secret = Secret['JWT_KEY']
    jwt_token = request.headers[HEADER_BEARER]
    data = JWT.decode(jwt_token, secret)
    ap data
    decoded = data[0]
    decoded.symbolize_keys!
  end
end
