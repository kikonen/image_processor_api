# frozen_string_literal: true

module AuthorizationSupport
  HEADER_BEARER = 'BEARER'

  def system_user
    @system_user ||= begin
      User.new(
        id: User::SYSTEM_ID,
        email: 'system@local')
    end
  end


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
      jwt_token = request.headers[HEADER_BEARER]
      Token.parse_token(jwt_token)
    end
  end

  def current_user
    @current_user ||= begin
      jwt = fetch_request_jwt
      if jwt[:system]
        system_user
      else
        User.find(fetch_request_jwt[:user])
      end
    end
  end
end
