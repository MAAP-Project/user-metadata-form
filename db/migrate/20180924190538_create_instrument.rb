class CreateInstrument < ActiveRecord::Migration[5.2]
  def change
    create_table :instruments do |t|
      t.belongs_to :platform, index: true
      t.string :name
    end
  end
end
