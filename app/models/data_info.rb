class DataInfo < ApplicationRecord
  PERMITTED_PARAMS = [
                      :questionnaire_id, :quality_assurance, :format, :size,
                      :format, :compression_state, :naming_convention_text,
                      :naming_convention_text, :naming_convention, :constraints
                     ]
   DATA_STATE = ['Compressed', 'Uncompressed', 'Combination of Both']
   SIZE_FORMAT = ['KB', 'MB', 'GB', 'TB']

  belongs_to :questionnaire, required: false

  def data_size
    [self.size, self.format].join(',')
  end

  validates_presence_of :format, :size, :size_format, :naming_convention_text,
                        :quality_assurance
end
