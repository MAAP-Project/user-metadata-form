class AddJobIdsAndUploadDirectoriesToCollectionInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_infos, :job_ids, :string, array: true, default: []
    add_column :collection_infos, :upload_directories, :string, array: true, default: []
  end
end

