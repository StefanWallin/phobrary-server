module ActionDispatch::Integration::RequestHelpers
  def options(path, parameters = nil, headers_or_env = nil)
    process :options, path, params: parameters, headers: headers_or_env
  end
end
