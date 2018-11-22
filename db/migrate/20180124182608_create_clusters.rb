class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.integer :members, array:true, default: []

      t.timestamps
    end
  end
end
