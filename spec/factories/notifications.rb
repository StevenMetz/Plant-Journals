FactoryBot.define do
  factory :notification do
    message { "MyString" }
    title { "MyString" }
    viewed { false }
    type { "" }
  end
end
