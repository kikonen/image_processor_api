# frozen_string_literal: true

class ApplicationController < ActionController::API
  include AuthorizationSupport

  before_action :require_authorization

  def protect_against_forgery?
    # NOTE KI no csrf in API
    false
  end
end
