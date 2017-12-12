json.extract! photo, :id, :digest, :filetype, :original_filename, :filename, :modifydate, :createdate, :make, :model, :orientation, :imagewidth, :imageheight, :gpslatitude, :gpslongitude, :created_at, :updated_at
json.url photo_url(photo, format: :json)
