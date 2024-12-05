FactoryBot.define do
  factory :feedback do
    message { "MyString" }
    rating { 1 }
    association :user
  end
end
