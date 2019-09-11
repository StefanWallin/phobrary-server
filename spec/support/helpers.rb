# frozen_string_literal: true

module Helpers
  def get_json(path)
    headers = { 'Accept' => 'application/json' }
    get path,
        params: nil,
        headers: headers
    JSON.parse(response.body, symbolize_names: true) if response.body.present?
  end

  def post_json(path, payload, headers: {})
    payload = payload.to_json unless payload.is_a? String
    headers.reverse_merge!(
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    )
    post path,
         params: payload,
         headers: headers
    JSON.parse response.body, symbolize_names: true if response.body.present?
  end
end

RSpec.configure do |config|
  config.include Helpers
end
