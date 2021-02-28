# frozen_string_literal: true

module Api
  module Sessions
    module V1
      class SessionsController < ApiController
        skip_before_action :verify_authenticity_token, only: :create
        skip_before_action :ensure_session!, only: :create
        skip_before_action :ensure_totp!, only: :create
        before_action :ensure_auth_attempt!, only: :create

        def create
          session = Authentication.create!(@auth_attempt, @device)
          render json: {
            status: 'ok',
            access_token: session.access_token,
            secret: @device.secret
          }, status: 201
        rescue Authentication::Unauthorized
          render json: { status: 'unauthorized' }, status: :unauthorized
        end

        private

        def ensure_auth_attempt!
          error = 'Unparseable one_time_code param'
          raise ArgumentError, error if params[:one_time_code].blank?

          @auth_attempt = AuthAttempt.find_by(secret: params[:one_time_code], expired: false)
        rescue ArgumentError => e
          log_exception(self.class, e)
          render status: :unauthorized, json: { errors: error, status: 'unauthorized' }
        end
      end
    end
  end
end
