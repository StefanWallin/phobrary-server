class AddSecretToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :secret, :string
  end
end
