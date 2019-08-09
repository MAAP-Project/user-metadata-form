class PersonCatalogue < ApplicationRecord
  belongs_to :person, required: false
  belongs_to :contact, required: false
end
