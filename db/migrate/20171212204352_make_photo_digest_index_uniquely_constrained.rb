class MakePhotoDigestIndexUniquelyConstrained < ActiveRecord::Migration[5.1]
  def change
    remove_index :photos, :digest
    add_index :photos, :digest, unique: true
  end
end
