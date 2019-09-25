class CreateUnprocessedFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :unprocessed_files do |t|
      t.string :file
      t.string :metadata
      t.timestamps
    end
  end
end
