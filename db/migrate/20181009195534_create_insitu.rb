class CreateInsitu < ActiveRecord::Migration[5.2]
  def change
    create_table :insitus do |t|
      t.belongs_to :spatial_extent, index: true
      t.string :measurement
      t.string :radius
      t.string :lon
      t.string :lat
      t.string :name
      t.timestamps
    end
  end
end
