module Api
  module Files
    module V1
      class FilesController < ApiController
        # Implements the tus.io file upload protocol:
        # https://github.com/tus/tus-resumable-upload-protocol
        VERSION = '1.0.0'
        SUPPORTED_VERSIONS = [VERSION]
        
        # skip_before_action :verify_authenticity_token, only: [:options]
        # skip_before_action :ensure_totp!, only: [:options]
        # skip_before_action :ensure_session!, only: [:options]

        def status
          head 200
        end

        def create # Implements the 'Creation' extension
          head 200
        end

        def update
          head 200
        end

        def options
          response.headers['Tus-Resumable'] = VERSION
          response.headers['Tus-Version'] = SUPPORTED_VERSIONS.join(',')
          response.headers['Tus-Max-Size'] = '1073741824' # Max 1 GB = 1024^3
          response.headers['Tus-Extension'] = 'creation'
          head 204
        end
      end
    end
  end
end
