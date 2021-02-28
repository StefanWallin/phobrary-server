class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices, id: :uuid do |t|
      t.string :name
      t.references :profile, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
