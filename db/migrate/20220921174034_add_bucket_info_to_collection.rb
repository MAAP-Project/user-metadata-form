class AddBucketInfoToCollection < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_infos, :bucket, :string
    add_column :collection_infos, :path, :string
    add_column :collection_infos, :filename_prefix, :string
  end
end
