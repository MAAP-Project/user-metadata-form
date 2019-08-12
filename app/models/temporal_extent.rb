class TemporalExtent < ApplicationRecord
  PERMITTED_PARAMS = [
                      :missing_explanation, :start_datetime, :end_datetime,
                      :questionnaire_id, :ongoing
                    ]

  belongs_to :questionnaire, required: false

  validates_presence_of :start_datetime
end
