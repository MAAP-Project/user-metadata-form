class SpatialExtent < ApplicationRecord
  PERMITTED_PARAMS = [
                       :geographic_regions, :data_nature, :questionnaire_id,
                       :bounding_box_north, :bounding_box_south, :bounding_box_east,
                       :bounding_box_west, :geolocated, :spatial_resolution,
                       insitus_attributes: [:radius, :lon, :radius, :measurement,
                       :lat, :name, :id, :_destroy]
                     ]

  DATA_NATURE = [
                  'Single Points', 'Multiple Points', 'Swath',
                  'Transect', 'Grid', 'Polygon', 'Line', 'Other'
                ]

  has_many :insitus
  belongs_to :questionnaire, required: false

  accepts_nested_attributes_for :insitus, allow_destroy: true, reject_if: lambda { |insitu| insitu['name'].blank? }

  def build_resources(questionnaire)
    self.insitus.build
    self
  end
end
