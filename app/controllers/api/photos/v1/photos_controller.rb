module Api
  module Photos
    module V1
      class PhotosController < ApiController
        def create
          unprocessed = UnprocessedFile.create!(file_params)
          unprocessed.raw_file.attach(params[:file])
          if unprocessed.save!
            head 200
          else
            render json: unprocessed.errors, status: :unprocessable_entity
          end
        end

        def file_params
          params.permit(:metadata, :file)
        end
      end
    end
  end
end
