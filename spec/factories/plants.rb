FactoryBot.define do
  factory :plant do
    title { Faker::Lorem.words(number: 2).join(' ') }
    description { Faker::Lorem.paragraph }
    likes { Faker::Lorem.sentence }
    dislikes { Faker::Lorem.sentence }
    water_frequency { Faker::Lorem.word }
    temperature { Faker::Lorem.word }
    sun_light_exposure { Faker::Lorem.word }
    association :user
  end
end
