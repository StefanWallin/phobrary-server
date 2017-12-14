json.extract! photo, :id, :digest, :filetype, :original_filepath, :current_filepath, :modifydate, :createdate, :make, :model, :orientation, :imagewidth, :imageheight, :gpslatitude, :gpslongitude, :created_at, :updated_at
json.url photo_url(photo, format: :json)
