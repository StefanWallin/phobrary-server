module Api
  module V1
    class SessionsController < ApiController
      def create
        if params[:token] == 'foobar'
          render json: { status: 'ok' }
        else
          render json: { status: 'unauthorized' }, status: 403
        end
      end
    end
  end
end
