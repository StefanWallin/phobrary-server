class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.string :hash
      t.string :filetype
      t.string :original_filename
      t.string :filename
      t.datetime :modifydate
      t.datetime :createdate
      t.string :make
      t.string :model
      t.string :orientation
      t.integer :imagewidth
      t.integer :imageheight
      t.string :gpslatitude
      t.string :gpslongitude

      t.timestamps
    end
  end
end
