class RenameHashToDigestForPhotos < ActiveRecord::Migration[5.1]
  def change
    rename_column :photos, :hash, :digest
  end
end
