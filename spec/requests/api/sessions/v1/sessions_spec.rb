# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/sessions/v1', type: :request do
  describe 'POST' do
    let(:secret) { 'barbaz' }
    let(:path) { '/api/sessions/v1' }

    context 'given an existing profile and valid auth_attempt' do
      before do
        AuthAttempt.create(profile: Profile.create(name: 'foo-user'), secret: secret)
      end

      it 'returns status code 201' do
        post_json(path, one_time_code: secret)
        expect(response.code).to eq('201')
      end

      it 'sets expired flag for used auth code' do
        auth_attempt = AuthAttempt.find_by(secret: secret)
        expect(auth_attempt.expired).to eq(false)
        post_json(path, one_time_code: secret)
        auth_attempt.reload
        expect(response.code).to eq('201')
        expect(auth_attempt.expired).to eq(true)
      end

      it 'expired? method returns correctly' do
        auth_attempt = AuthAttempt.find_by(secret: secret)
        expect(auth_attempt.expired?).to eq(false)
        post_json(path, one_time_code: secret)
        auth_attempt.reload
        expect(response.code).to eq('201')
        expect(auth_attempt.expired?).to eq(true)
      end

      it 'registers a new device' do
        expect(Device.count).to eq(0)
        post_json(path, one_time_code: secret)
        profile = Profile.find_by(name: 'foo-user')
        expect(response.code).to eq('201')
        expect(profile.devices.last).not_to eq(nil)
      end

      it 'creates a session for the device' do
        expect(Session.count).to eq(0)
        post_json(path, one_time_code: secret)
        profile = Profile.find_by(name: 'foo-user')
        expect(response.code).to eq('201')
        expect(profile.devices.last.sessions.last).not_to eq(nil)
      end

      it 'returns status in json' do
        post_json(path, one_time_code: secret)
        expect(response.code).to eq('201')
        expect(response.body).to include('"status":"ok"')
      end

      it 'returns access_token in json' do
        post_json(path, one_time_code: secret)
        session = Session.last
        expect(response.code).to eq('201')
        expect(response.body).to include("\"access_token\":\"#{session.access_token}\"")
      end

      it 'succeeds with only 2 seconds until expiry' do
        profile = Profile.last
        AuthAttempt.last.update(secret: secret, expired: false, created_at: 10.minutes.ago + 2.seconds)
        post_json(path, one_time_code: secret)
        expect(response.code).to eq('201')
      end
    end

    context 'given an existing profile without a valid auth_attempt' do
      before do
        Profile.create(name: 'foo-user')
      end

      context 'returns status code 401' do
        it 'when auth_attempt is non-existing' do
          post_json(path, one_time_code: secret)
          expect(response.code).to eq('401')
        end

        it 'when secret is nil' do
          post_json(path, one_time_code: nil)
          expect(response.code).to eq('401')
        end

        it 'when auth_attempt is marked as expired' do
          profile = Profile.last
          AuthAttempt.create(profile: profile, expired: true, secret: secret)
          post_json(path, one_time_code: secret)
          expect(response.code).to eq('401')
        end

        it 'when auth_attempt has expired by time' do
          profile = Profile.last
          AuthAttempt.create(profile: profile, expired: false, secret: secret, created_at: 10.minutes.ago)
          post_json(path, one_time_code: secret)
          expect(response.code).to eq('401')
        end
      end
    end
  end

  def post_json(path, incomingParams = {}, headers = {})
    params = {
      device_id: '01234567-0123-0123-0123-012345678901',
      app_version: 'app_version'
    }.merge(incomingParams)
    headers = {
      Accept: 'application/json',
      'Content-Type' => 'application/json'
    }.merge(headers)
    post(
      path,
      params: params.to_json,
      headers: headers
    )
  end

  def headers
    {
      Accept: 'application/json',
      'Content-Type' => 'application/json'
    }
  end
end
