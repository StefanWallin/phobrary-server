class CreateShotsAndCameras < ActiveRecord::Migration[5.1]
  def change
    create_table :cameras do |t|
      t.string :make
      t.string :model
    end
    add_index :cameras, :make
    add_index :cameras, :model

    create_table :shots do |t|
      t.string :name
      t.string :orientation
      t.string :gpslatitude
      t.string :gpslongitude
      t.integer :camera_id
      t.datetime :date

      t.timestamps
    end

    add_column :photos, :shot_id, :integer

    add_foreign_key :shots, :cameras
    add_foreign_key :photos, :shots

    add_index :shots, :date

    remove_column :photos, :make, :string
    remove_column :photos, :model, :string
    remove_column :photos, :orientation, :string
    remove_column :photos, :gpslatitude, :string
    remove_column :photos, :gpslongitude, :string
  end
end
