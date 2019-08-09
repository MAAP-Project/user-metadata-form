class CreateQuestionnaire < ActiveRecord::Migration[5.2]
  def change
    create_table :questionnaires do |t|
      t.string :user_name
      t.string :user_email
      t.boolean :finished
      t.timestamps
    end
  end
end
