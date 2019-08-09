class Instrument < ApplicationRecord
  belongs_to :platform, required: false

  validates_presence_of :name
end
