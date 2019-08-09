class OrganizationCatalogue < ApplicationRecord
  belongs_to :organization, required: false
  belongs_to :contact, required: false
end
