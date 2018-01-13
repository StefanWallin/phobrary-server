class CreateFolders < ActiveRecord::Migration[5.1]
  def change
    create_table :folders do |t|
      t.string :path
      t.integer :folder_id
      t.integer :depth

      t.timestamps
    end
  end
end
