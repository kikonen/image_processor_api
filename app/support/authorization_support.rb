# frozen_string_literal: true

module AuthorizationSupport
  HEADER_BEARER = 'BEARER'
  TOKEN_EXPIRE = 1.day

  SYSTEM_USER = User.new(
    id: '00000000-0000-0000-0000-000000000000',
    email: 'system@local')


  def require_authorization
    check_jwt_token
  end

  def check_jwt_token
    jwt = fetch_request_jwt
    current_user
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

  def current_user
    @current_user ||= begin
      jwt = fetch_request_jwt
      if jwt[:system]
        SYSTEM
      else
        User.find(fetch_request_jwt[:user])
      end
    end
  end
end
