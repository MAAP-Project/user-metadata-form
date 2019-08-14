class CreateKeyword < ActiveRecord::Migration[5.2]
  def change
    create_table :keywords do |t|
      t.belongs_to :questionnaire, index: true
      t.string :science_keywords
      t.string :ancillary_keywords
      t.timestamps
    end
  end
end
