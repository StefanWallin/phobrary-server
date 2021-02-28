class CreateAuthAttempts < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_attempts, id: :uuid do |t|
      t.references :profile, type: :uuid, foreign_key: true
      t.string :secret
      t.boolean :expired, null: false, default: false

      t.timestamps
    end
    add_index :auth_attempts, :expired
  end
end
