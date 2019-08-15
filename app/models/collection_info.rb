class CollectionInfo < ApplicationRecord
  PERMITTED_PARAMS = [
    :title, :short_title, :version, :version_description, :abstract, :status, :questionnaire_id, job_ids: []
  ]

  belongs_to :questionnaire, required: false

  validates_presence_of :title, :short_title, :version, :abstract
end
