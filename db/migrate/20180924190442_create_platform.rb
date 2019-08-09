class CreatePlatform < ActiveRecord::Migration[5.2]
  def change
    create_table :platforms do |t|
      t.belongs_to :questionnaire
      t.string :name

      t.timestamps
    end
  end
end
