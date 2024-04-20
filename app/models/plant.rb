class Plant < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :water_frequency, presence: true
  belongs_to :plant_journal
  belongs_to :user
end
