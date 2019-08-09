class CreateContact < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.belongs_to :questionnaire, index: true
      t.timestamps
    end
  end
end
