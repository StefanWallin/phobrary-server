# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :ensure_device!
  before_action :ensure_totp!
  before_action :ensure_session!

  def ensure_device!
    device_id = params[:device_id]
    app_version = params[:app_version] # TODO: Store app_version in device db (also make sure it's sent from app)
    device_name = params[:device_name] # TODO: Get device_name from app
    return head 400 if device_id.blank?
    return head 400 unless uuid_valid?(device_id)

    @device = Device.find_and_update(id: device_id, name: device_name)
  end

  def ensure_totp!
    authenticated = Authentication.authenticated?(totp, @device)
  end

  def ensure_session!
    authorized = Authentication.authorized?(current_session)
    return true if authorized

    message = 'Not Authorized, missing or invalid session token header: X-PHOB-Token'
    render json: { errors: [{ message: message }] }, status: 403
  end


  def current_session
    @session ||= Session.find_by(access_token: access_token)
  end

  def access_token
    @access_token ||= request.headers['X-PHOB-Token'].presence
  end

  def totp
    @totp ||= request.headers['X-PHOB-TOTP'].presence
  end

  def uuid_valid?(uuid)
    return false if /\A[0\-]{36}\z/i.match?(uuid) # Disallow null uuid
    return true if /\A[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i.match?(uuid) # Valid uuid incl null uuid

    false
  end
end
