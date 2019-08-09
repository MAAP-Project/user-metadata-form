class CreateOrganizationCatalogue < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_catalogues do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :contact, index: true

      t.timestamp
    end
  end
end
