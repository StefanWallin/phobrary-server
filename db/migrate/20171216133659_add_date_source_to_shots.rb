class AddDateSourceToShots < ActiveRecord::Migration[5.1]
  def change
    add_column :shots, :date_source, :string
  end
end
