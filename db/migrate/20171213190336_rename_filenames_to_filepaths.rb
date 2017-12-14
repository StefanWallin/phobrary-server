class RenameFilenamesToFilepaths < ActiveRecord::Migration[5.1]
  def change
    rename_column :photos, :filename, :current_filepath
    rename_column :photos, :original_filename, :original_filepath
  end
end
