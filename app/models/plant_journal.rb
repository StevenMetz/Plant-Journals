class PlantJournal < ApplicationRecord
  validates :title, presence: true
  validates :user_id, presence: true
  belongs_to :user
  has_many :plants
end
