# frozen_string_literal: true

require 'rails_helper'

# Implements the tus.io file upload protocol with version 1.0.0:
# https://github.com/tus/tus-resumable-upload-protocol

RSpec.describe '/api/files/v1', type: :request do
  describe 'OPTIONS' do
    let!(:profile) { Profile.create(name: 'foo-user') }
    let!(:device) { Device.create(profile_id: profile.id) }
    let!(:session) { Session.create!(
      device: device,
      access_token: SecureRandom.urlsafe_base64(64)
    ) }
    let(:path) { '/api/files/v1' }

    context 'given an existing profile, device and valid session' do
      before do
        tus_request(:options, path, device: device, session: session)
      end

      it 'returns status code 204' do
        expect(response.code).to eq('204')
      end

      it 'returns header Tus-Resumable with version 1.0.0' do
        expect(response.headers['Tus-Resumable']).to eq('1.0.0')
      end

      it 'returns header Tus-Version with version 1.0.0' do
        expect(response.headers['Tus-Version']).to eq('1.0.0')
      end

      it 'returns header Tus-Max-Size with version 1073741824' do
        expect(response.headers['Tus-Max-Size']).to eq('1073741824')
      end

      it 'returns header Tus-Extension with version creation' do
        expect(response.headers['Tus-Extension']).to eq('creation')
      end
    end
  end

  describe 'POST' do
    let!(:profile) { Profile.create(name: 'foo-user') }
    let!(:device) { Device.create(profile_id: profile.id) }
    let!(:session) { Session.create!(
      device: device,
      access_token: SecureRandom.urlsafe_base64(64)
    ) }

    let(:path) { '/api/files/v1' }
    
    xcontext 'given an existing profile, device and valid session' do
      it 'returns status code 204' do
        expect(response.code).to eq('204')
      end

      it 'returns header Tus-Resumable with version 1.0.0' do
        expect(response.headers['Tus-Resumable']).to eq('1.0.0')
      end

      it 'returns header Tus-Version with version 1.0.0' do
        expect(response.headers['Tus-Version']).to eq('1.0.0')
      end

      it 'returns header Tus-Max-Size with version 1073741824' do
        expect(response.headers['Tus-Max-Size']).to eq('1073741824')
      end

      it 'returns header Tus-Extension with version creation' do
        expect(response.headers['Tus-Extension']).to eq('creation')
      end
    end
  end

  def tus_request(method, path, device:, session:, params: {}, headers: {})
    rotp = ROTP::TOTP.new(device.secret)
    totp = rotp.now
    params = {
      device_id: device.id,
      app_version: 'app_version'
    }.merge(params)
    headers = {
      'Tus-Resumeable' => '1.0.0',
      'X-PHOB-TOTP' => totp,
      'X-PHOB-Token' => session.access_token
    }.merge(headers)
    case method
    when :options
      options(path, params, headers)
    when :post
      post(path, params, headers)
    when :patch
      patch(path, params, headers)
    when :head
      head(path, params, headers)
    end
  end
end
