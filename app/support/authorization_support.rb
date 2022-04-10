# frozen_string_literal: true

module AuthorizationSupport
  HEADER_BEARER = 'BEARER'
  TOKEN_EXPIRE = 1.day

  def require_authorization
    check_jwt_token
  end

  def check_jwt_token
    jwt = fetch_request_jwt
    dt = Time.at(jwt[:exp])
    Rails.logger.info "Date: #{dt}"
  end

  def fetch_request_jwt
    @request_jwt ||= begin
      secret = Secret['JWT_KEY']
      jwt_token = request.headers[HEADER_BEARER]
      data = JWT.decode(jwt_token, secret)
      Rails.logger.info(data)
      decoded = data[0]
      decoded.symbolize_keys!
    end
  end
end
