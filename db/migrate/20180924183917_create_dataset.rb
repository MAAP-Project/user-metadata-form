class CreateDataset < ActiveRecord::Migration[5.2]
  def change
    create_table :datasets do |t|
      t.belongs_to :questionnaire, index: true
      t.string :title
      t.string :version
      t.string :version_description
      t.string :description
      t.string :doi
      t.string :processing_level
      t.string :public

      t.timestamps
    end
  end
end
