class Plant < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :water_frequency, presence: true
end
