module Api
  module Photos
    module V1
      class PhotosController < ApiController
        def create
          @file = UnprocessedFile.new(file_params)
          if @file.save
            head 200
          else
            render json: @file.errors, status: :unprocessable_entity
          end
        end

        def file_params
          {
            file: params[:file],
            metadata: params[:metadata]
          }
        end
      end
    end
  end
end
