class PlantJournal < ApplicationRecord
  validates :title, presence: true
  validates :user_id, presence: true
  belongs_to :user
  has_and_belongs_to_many :plants
  has_many :shared_journals
  has_many :shared_users, through: :shared_journals, source: :user
end
