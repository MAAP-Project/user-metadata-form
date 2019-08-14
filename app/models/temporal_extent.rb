class TemporalExtent < ApplicationRecord
  PERMITTED_PARAMS = [
                      :missing_explanation, :start_date, :end_date,
                      :questionnaire_id, :ongoing
                    ]

  belongs_to :questionnaire, required: false

  validates_presence_of :start_date
end
