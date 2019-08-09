class Person < ApplicationRecord
  belongs_to :questionnaire, required: false

  validates_presence_of :first_name, :last_name, :email, :role
end
