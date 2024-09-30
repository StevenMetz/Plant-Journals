class Plant < ApplicationRecord
  belongs_to :plant_journal, optional: true
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :description, presence: true
  validates :water_frequency, presence: true
end
