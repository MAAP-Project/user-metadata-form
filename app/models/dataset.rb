class Dataset < ApplicationRecord
  PERMITTED_PARAMS = [
                       :title, :version, :version_description, :description,
                       :doi, :processing_level, :other_processing_level, :questionnaire_id, :public
                     ]

  NASA_LEVELS = ['1A', '1B', '2', '3', '4']

  AVAILABILITY_OPTIONS = [
    'Yes, this data is freely available to the public',
    'This data is available to the public, but it costs money',
    'The data is not currently available to the public, but there are plans to make it available',
    'The data is not currently available to the public, but I would like to make it publically available through the MAAP',
    'The data is not publically available and there are no plans to make it available',
  ]

  belongs_to :questionnaire, required: false

  validates_presence_of :title, :version, :doi, :description
end
