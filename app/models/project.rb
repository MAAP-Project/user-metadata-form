class Project < ApplicationRecord
  PERMITTED_PARAMS = [:agency, :name, :program, :questionnaire_id]
  belongs_to :questionnaire, required: false
end
