require "tus/storage/filesystem"

Tus::Server.opts[:storage] = Tus::Storage::Filesystem.new("public/tus")
Tus::Server.opts[:max_size] = 0.1 * 1024*1024*1024 # 0.1GB
Tus::Server.opts[:expiration_time] = 2*24*60*60 # 2 days


Tus::Server.before_create do |uid, info|
  params = ActiveSupport::HashWithIndifferentAccess.new(request.params)
  auth = AuthenticationManager.new(request, params)
  authenticated, error = auth.authenticated_upload?
  authenticated, errors = auth.authenticated_upload?
  unless authenticated
    response.status = 403
    message = "Not authenticated, #{errors.to_json}"
    response.write(message)
    Rails.logger.info(message)
    request.halt
  end
end

Tus::Server.after_finish do |uid, info|
  params = ActiveSupport::HashWithIndifferentAccess.new(request.params)
  auth = AuthenticationManager.new(request, params)
  username = auth.current_device.profile.name
  filename = info.metadata['filename']
  Rails.logger.info "#{username} Uploaded #{filename} successfully"
  FileManager.move_uploaded_file(uid, filename, username)
end
