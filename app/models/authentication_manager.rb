# frozen_string_literal: true

class AuthenticationManager
  TOTP_HEADER_NAME = 'X-PHOB-TOTP'
  SESSION_TOKEN_HEADER_NAME = 'X-PHOB-Token'
  DEVICE_ID_HEADER_NAME = 'X-PHOB-DeviceID'
  APP_VERSION_HEADER_NAME = 'X-PHOB-AppVersion'
  DEVICE_NAME_HEADER_NAME = 'X-PHOB-DeviceName'
  INVALID_SESSION_MSG = "Missing or invalid session token header: '#{SESSION_TOKEN_HEADER_NAME}'"
  INVALID_TOTP_MSG = "Missing or invalid request one time password header: '#{TOTP_HEADER_NAME}'"

  def initialize(request, params)
    @request = request
    @params = params
    @errors = []
  end

  def authenticated?
    authenticated = valid_device? && valid_session? && valid_totp?
    return authenticated, @errors
  end

  def authenticated_upload?
    authenticated = valid_device? && valid_session?
    return authenticated, @errors
  end

  def valid_device?
    if device_id.blank?
      @errors.push("device_id missing: '#{device_id}'")
      return false
    end
    if app_version.blank?
      @errors.push("app_version missing: '#{app_version}'")
      return false
    end
    # if device_name.blank?
    #   @errors.push("device_name missing: '#{device_name}'")
    #   return false
    # end
    valid_device_id = valid_uuid?(device_id)
    unless valid_device_id
      @errors.push("device_id not valid uuid: '#{device_id}")
      return false
    end

    @device = Device.find_and_update(id: device_id, name: device_name, app_version: app_version)
    true
  end

  def current_device
    @device ||= Device.find(device_id)
  end

  def current_session
    @session ||= Session.find_by(access_token: access_token)
  end


  private

  def device_id
    @device_id ||= @params[:device_id] || @request.headers[DEVICE_ID_HEADER_NAME]
  end

  def device_name
    @device_name ||= @params[:device_name] || @request.headers[DEVICE_NAME_HEADER_NAME]
  end

  def app_version
    @app_version ||= @params[:app_version] || @request.headers[APP_VERSION_HEADER_NAME]
  end

  def valid_session?
    valid_session = Authentication.valid_session?(current_session)
    @errors.push(INVALID_SESSION_MSG) unless valid_session
    valid_session
  end

  def valid_totp?
    valid_totp = Authentication.valid_totp?(totp, current_device)
    @errors.push(INVALID_TOTP_MSG) unless valid_totp
    valid_totp
  end

  def valid_uuid?(uuid)
    return false if /\A[0\-]{36}\z/i.match?(uuid) # Disallow null uuid
    return true if /\A[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i.match?(uuid) # Valid uuid incl null uuid

    false
  end

  def access_token
    @access_token ||= @request.headers[SESSION_TOKEN_HEADER_NAME].presence
  end
  
  def totp
    @totp ||= @request.headers[TOTP_HEADER_NAME].presence
  end

end
