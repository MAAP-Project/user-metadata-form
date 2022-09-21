class CollectionInfo < ApplicationRecord
  PERMITTED_PARAMS = [
    :title, :short_title, :version, :version_description,
    :abstract, :status, :questionnaire_id, :bucket, :path,
    :filename_prefix, :filename_regex
  ]

  belongs_to :questionnaire, required: false

  validates_presence_of :title, :short_title, :version, :abstract
  validates :filename_prefix, presence: true, unless: :filename_regex
  validates :filename_regex, presence: true, unless: :filename_prefix 
end
