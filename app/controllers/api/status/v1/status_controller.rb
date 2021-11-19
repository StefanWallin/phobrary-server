# frozen_string_literal: true

module Api
  module Status
    module V1
      class StatusController < ApiController
        before_action :ensure_device!, only: :index
        skip_before_action :ensure_authenticated!, only: :index

        def index
          Rails.logger.info params.inspect
          render json: {
            status: 'ok',
            device_id: current_device.id,
            device_name: current_device.name,
            server_uuid: Rails.application.config.server[:server_uuid]
          }
        end
      end
    end
  end
end
