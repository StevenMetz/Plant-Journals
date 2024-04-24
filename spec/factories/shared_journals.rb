FactoryBot.define do
  factory :shared_journal do
    association :user
    association :plant_journal
  end
end
