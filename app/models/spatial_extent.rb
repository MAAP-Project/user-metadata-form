class SpatialExtent < ApplicationRecord
  PERMITTED_PARAMS = [
                       :questionnaire_id, :spatial_nature,
                       :bounding_box_north, :bounding_box_south, :bounding_box_east,
                       :bounding_box_west
                     ]

  SPATIAL_NATURE = [ 'Cartesian', 'Geodetic', 'Orbit', 'Other' ]

  belongs_to :questionnaire, required: false
  validates_presence_of :spatial_nature
end
