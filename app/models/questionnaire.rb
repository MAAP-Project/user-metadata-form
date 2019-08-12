class Questionnaire < ApplicationRecord
  PERMITTED_PARAMS = ['user_name', 'user_email', 'uid', {
    platforms_attributes: [
      :id, :questionnaire_id, :name, :_destroy,
      { instruments_attributes: [:id, :name, :_destroy] }
    ]
  }]

  RELATIONS = [
                'contact', 'project', 'dataset', 'data_info', 'temporal_extent',
                'spatial_extent', 'related_info', 'collection_info', 'keyword'
              ]

  RELATIONS.each do |relation|
    has_one relation.to_sym
  end
  has_many :platforms

  validates_presence_of :user_name, :user_email, :uid
  accepts_nested_attributes_for :platforms, allow_destroy: true,
    reject_if: lambda { |platform| platform['name'].blank? }

  def filled_by
    [self.user_name, self.user_email].join('|')
  end

  def questionnaire
    self
  end

  def destroy_relations
    RELATIONS.each do |relation|
      self.send(relation)&.delete
    end
    self.platforms.delete_all
  end

  def uuid
    _uuid = self.uid || SecureRandom.uuid
    if self.new_record?
      if Questionnaire.where(uid: _uuid).blank?
        self.uid = _uuid
      else
        self.uid = self.uuid
      end
    end
    self.uid
  end
end
