# Seeds for creating users
20.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: 'password', # You might want to change this
    name: Faker::Name.name
  )
end

# Seeds for creating plants and journals with random user assignments
1000.times do
  user = User.offset(rand(User.count)).first

  plant_journal = PlantJournal.create!(
    title: Faker::Lorem.sentence,
    user_id: user.id
  )

  Plant.create!(
    title: Faker::Lorem.word,
    description: Faker::Lorem.paragraph,
    likes: Faker::Lorem.sentence,
    dislikes: Faker::Lorem.sentence,
    water_frequency: Faker::Lorem.word,
    temperature: Faker::Lorem.word,
    sun_light_exposure: Faker::Lorem.word,
    plant_journal_id: plant_journal.id,
    user_id: user.id
  )
end

# Seeds for creating shared journals
20.times do
  user = User.offset(rand(User.count)).first
  plant_journal = PlantJournal.offset(rand(PlantJournal.count)).first

  SharedJournal.create!(
    user_id: user.id,
    plant_journal_id: plant_journal.id
  )
end
