class CreateOrganization < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.belongs_to :contact, index: true
      t.string :name
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
