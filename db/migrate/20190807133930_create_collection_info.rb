class CreateCollectionInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_infos do |t|
      t.belongs_to :questionnaire, index: true
      t.string :title
      t.string :short_title
      t.string :version
      t.string :version_description
      t.string :abstract
      t.string :status
      t.timestamps
    end
  end
end
