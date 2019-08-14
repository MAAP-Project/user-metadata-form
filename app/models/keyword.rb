class Keyword < ApplicationRecord
   PERMITTED_PARAMS = [:questionnaire_id,
                      :science_keywords, :ancillary_keywords,
                     ]
   SCIENCE_KEYWORDS = ['One', 'Two', 'Three']

  belongs_to :questionnaire, required: false

  validates_presence_of :science_keywords, :ancillary_keywords
end
