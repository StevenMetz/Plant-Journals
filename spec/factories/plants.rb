FactoryBot.define do
  factory :plant do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    likes { Faker::Lorem.sentence }
    dislikes { Faker::Lorem.sentence}
    water_frequency { Faker::Lorem.word }
    temperature { Faker::Lorem.word }
    sun_light_exposure { Faker::Lorem.word }
    user_id { association :user }
    plant_journal_id {association :plant_journal}
  end
end
