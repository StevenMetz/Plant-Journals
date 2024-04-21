class Plant < ApplicationRecord
  belongs_to :plant_journal, optional: true
  belongs_to :user
  validates :title, presence: true
  validates :description, presence: true
  validates :water_frequency, presence: true
end
