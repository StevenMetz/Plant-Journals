User.destroy_all
Plant.destroy_all
PlantJournal.destroy_all
SharedJournal.destroy_all

# Create 10 users
10.times do |user_index|
  User.create!(
    email: "user#{user_index+1}@example.com",
    password: 'password',
    name: "User #{user_index+1}"
  )
end

# Get all users
users = User.all

users.each do |user|
  3.times do |journal_index|
    journal = PlantJournal.create!(
      title: "Journal #{user.id}-#{journal_index+1}",
      user: user
    )

    4.times do |plant_index|
      plant = Plant.create!(
        title: "Plant #{user.id}-#{journal_index+1}-#{plant_index+1}",
        description: "Plant description",
        user: user,
        water_frequency: "Weekly"
      )
      journal.plants << plant
    end

    # Share the journal with 2 other random users
    2.times do
      shared_user = users.sample # Randomly select a user
      SharedJournal.create!(user: shared_user, plant_journal: journal) unless shared_user == user
    end
  end
end
