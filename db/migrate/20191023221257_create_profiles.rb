class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_index :profiles, :name, unique: true
  end
end
