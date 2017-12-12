class AddIndexToPhotoBaseData < ActiveRecord::Migration[5.1]
  def change
    add_index :photos, :hash
    add_index :photos, :filetype
    add_index :photos, :original_filename
    add_index :photos, :filename
    add_index :photos, :createdate
  end
end
