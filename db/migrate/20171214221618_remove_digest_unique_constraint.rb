class RemoveDigestUniqueConstraint < ActiveRecord::Migration[5.1]
  def change
    remove_index :photos, :digest
    add_index :photos, :digest, unique: false
  end
end
