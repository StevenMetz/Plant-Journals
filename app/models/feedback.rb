class Feedback < ApplicationRecord
  belongs_to :user
  validates :rating, presence: true
  validates :message, presence: true
end
