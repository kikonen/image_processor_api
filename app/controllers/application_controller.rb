# frozen_string_literal: true

class ApplicationController < ActionController::API
  include AuthorizationSupport

  respond_to :json

  before_action :require_authorization

  rescue_from ActiveRecord::RecordNotFound, with: :response_not_found
  def protect_against_forgery?
    # NOTE KI no csrf in API
    false
  end

  def response_not_found
    respond_with '{"error": "not_found"}', status: :not_found
  end
end
