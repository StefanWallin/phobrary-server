# frozen_string_literal: true

module Api
  module Status
    module V1
      class StatusController < ApiController
        skip_before_action :ensure_totp!, only: :index
        skip_before_action :ensure_session!, only: :index

        def index
          Rails.logger.info params.inspect
          render json: {
            status: 'ok',
            device_id: @device.id,
            device_name: @device.name,
            server_uuid: Rails.application.config.server[:server_uuid]
          }
        end
      end
    end
  end
end
