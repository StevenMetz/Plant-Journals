class Notification < ApplicationRecord
  belongs_to :user
  enum notification_type: { alert: 0, reminder: 1, message: 2 }
end
