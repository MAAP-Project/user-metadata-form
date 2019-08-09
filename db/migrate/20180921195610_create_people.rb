class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.belongs_to :contact, index: true
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
