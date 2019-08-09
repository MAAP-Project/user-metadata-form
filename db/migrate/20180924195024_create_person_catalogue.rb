class CreatePersonCatalogue < ActiveRecord::Migration[5.2]
  def change
    create_table :person_catalogues do |t|
      t.belongs_to :person, index: true
      t.belongs_to :contact, index: true

      t.timestamp
    end
  end
end
