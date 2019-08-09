class CreateDataInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :data_infos do |t|
      t.belongs_to :questionnaire, index: true
      t.string :format
      t.float :size
      t.string :constraints
      t.string :compression_state
      t.string :naming_convention_text
      t.string :naming_convention
      t.string :quality_assurance
      t.string :software_package
      t.timestamps
    end
  end
end
