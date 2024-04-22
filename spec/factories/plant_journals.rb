FactoryBot.define do
  factory :plant_journal do
    title { Faker::Lorem.word }
    user { association :user }
  end
end
