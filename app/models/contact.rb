class Contact < ApplicationRecord
  PERMITTED_PARAMS = [
                       {
                          people_attributes: [:id, :first_name, :middle_name, :last_name, :email, :role, :_destroy],
                          organizations_attributes: [:id, :name, :email, :role, :_destroy]
                        },
                       :questionnaire_id
                     ]

  ROLES = ['Technical Contact', 'Science Contact', 'Investigator']

  belongs_to :questionnaire
  has_many :person_catalogues
  has_many :people, through: :person_catalogues

  has_many :organization_catalogues
  has_many :organizations, through: :organization_catalogues

  accepts_nested_attributes_for :people, allow_destroy: true, reject_if: lambda { |person| person['first_name'].blank? }
  accepts_nested_attributes_for :organizations, allow_destroy: true, reject_if: lambda { |org| org['name'].blank? }

  validate :person_or_contact

  def build_resources(questionnaire)
    self.people.build
    self.organizations.build
    self
  end

  private

  def person_or_contact
    if people.blank? && organizations.blank?
      errors.add(:base, "Please provide atleast one contact person or organization.")
    else
      self.save(validate: false)
    end
  end
end
