class RelatedInfo < ApplicationRecord
  PERMITTED_PARAMS = [
                       :questionnaire_id, :published_paper_url,
                       :user_documentation_url, :algo_documentation_url,
                       :additional_info, :browse_imagery,
                       algo_documentation: [], user_documentation: [],
                       published_paper: []
                     ]
  mount_uploaders :published_paper, FileUploader
  mount_uploaders :user_documentation, FileUploader
  mount_uploaders :algo_documentation, FileUploader

  belongs_to :questionnaire, required: false
end