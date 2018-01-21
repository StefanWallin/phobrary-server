class AddFolderToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_reference :photos, :folder, foreign_key: true
  end
end
