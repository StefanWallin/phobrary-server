# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/sessions/v1', type: :request do
  describe 'POST /' do
    it 'returns status ok for valid token' do
      body = post_json('/api/sessions/v1/', { token: 'foobar' })
      expect(body[:status]).to eq('ok')
      expect(response.status).to eq(200)
    end

    it 'returns status unauthorized for invalid token' do
      body = post_json('/api/sessions/v1/', { token: 'barbaz' })
      expect(body[:status]).to eq('unauthorized')
      expect(response.status).to eq(403)
    end
  end
end
