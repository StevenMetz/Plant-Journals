FactoryBot.define do
  factory :notification do
    message { "Test notification message" }
    title { "Test notification" }
    viewed { false }
    notification_type { 0 }
    association :user
  end
end
