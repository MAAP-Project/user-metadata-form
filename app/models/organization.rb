class Organization < ApplicationRecord
  has_many :organization_catalogues
  has_many :contacts, through: :organization_catalogues

  belongs_to :questionnaire, required: false

  validates_presence_of :name, :email, :role
end
