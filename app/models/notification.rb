class Notification < ApplicationRecord
  validates :title, presence: true
  validates :message, presence: true
  belongs_to :user
  enum notification_type: { alert: 0, reminder: 1, message: 2 }
end
