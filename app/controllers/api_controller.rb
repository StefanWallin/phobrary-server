# frozen_string_literal: true

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :ensure_authenticated!

  def ensure_device!
    auth = AuthenticationManager.new(request, params)
    return head 400 unless auth.valid_device?
  end

  def ensure_authenticated!
    auth = AuthenticationManager.new(request, params)
    return head 400 unless auth.valid_device?
    authenticated, errors = auth.authenticated?
    return render json: errors, status: 401 if !authenticated
  end

  def current_device
    auth = AuthenticationManager.new(request, params)
    auth.current_device
  end
end
