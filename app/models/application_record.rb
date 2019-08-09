class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def build_resources(questionnaire)
    #just a holder for consistency
    self
  end
end
