class Plant < ApplicationRecord
  has_and_belongs_to_many :plant_journals, optional: :true
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :description, presence: true
  validates :water_frequency, presence: true
  validates :user_id, presence: :true
end
