class AddColumnToDataset < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :other_processing_level, :string
  end
end
