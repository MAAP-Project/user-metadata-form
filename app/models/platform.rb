class Platform < ApplicationRecord
  belongs_to :questionnaire, required: false
  has_many :instruments

  accepts_nested_attributes_for :instruments, allow_destroy: true

  validates_presence_of :name

  accepts_nested_attributes_for :instruments, allow_destroy: true, reject_if: lambda { |inst| inst['name'].blank? }

  def build_resources(questionnaire)
    self.instruments.build
    questionnaire.platforms << self
    questionnaire
  end
end
