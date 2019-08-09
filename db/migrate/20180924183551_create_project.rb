class CreateProject < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.belongs_to :questionnaire
      t.string :name
      t.string :agency
      t.string :program

      t.timestamps
    end
  end
end
