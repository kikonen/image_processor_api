# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthorizationSupport

  before_action :require_authorization

end
