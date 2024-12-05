FactoryBot.define do
  factory :feedback do
    user_id { 1 }
    message { "MyString" }
    rating { 1 }
  end
end
