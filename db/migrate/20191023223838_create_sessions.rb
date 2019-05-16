class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :device, type: :uuid, foreign_key: true
      t.string :access_token
      t.boolean :expired, null: false, default: false
      t.datetime :active_at

      t.timestamps
    end
    add_index :sessions, :access_token
  end
end
