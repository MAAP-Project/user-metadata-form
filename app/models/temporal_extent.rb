class TemporalExtent < ApplicationRecord
  PERMITTED_PARAMS = [
                      :missing_explanation, :end_date, :start_date,
                      :questionnaire_id, :ongoing
                    ]

  belongs_to :questionnaire, required: false

  validates_presence_of :start_date
end
