class CreateVariable < ActiveRecord::Migration[5.2]
  def change
    create_table :variables do |t|
      t.belongs_to :data_info
      t.string :name
      t.string :unit
      t.float :scaling_factor

      t.timestamps
    end
  end
end
