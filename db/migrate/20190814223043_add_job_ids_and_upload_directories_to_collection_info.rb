class AddJobIdsAndUploadDirectoriesToCollectionInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_infos, :bucket, :string
    add_column :collection_infos, :upload_directories, :string, array: true, default: []
  end
end

