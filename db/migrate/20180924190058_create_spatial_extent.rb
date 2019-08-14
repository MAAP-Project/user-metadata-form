class CreateSpatialExtent < ActiveRecord::Migration[5.2]
  def change
    create_table :spatial_extents do |t|
      t.belongs_to :questionnaire
      t.string :spatial_nature
      t.string :bounding_box_north
      t.string :bounding_box_south
      t.string :bounding_box_west
      t.string :bounding_box_east
      t.timestamps
    end
  end
end
