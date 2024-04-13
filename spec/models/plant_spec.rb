require 'rails_helper'

RSpec.describe Plant, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      plant = Plant.new(
        title: "Test Plant",
        description: "This is a test plant",
        likes: 10,
        dislikes: 2,
        water_frequency: "Weekly",
        temperature: "Moderate",
        sun_light_exposure: "Partial Sun"
      )
      expect(plant).to be_valid
    end

    it "is not valid without a title" do
      plant = Plant.new(title: nil)
      expect(plant).not_to be_valid
      expect(plant.errors[:title]).to include("can't be blank")
    end
    it "is not valid without a description" do
      plant = Plant.new(description: nil)
      expect(plant).not_to be_valid
      expect(plant.errors[:description]).to include("can't be blank")
    end
    it "is not valid without a water_frequency" do
      plant = Plant.new(water_frequency: nil)
      expect(plant).not_to be_valid
      expect(plant.errors[:water_frequency]).to include("can't be blank")
    end
  end
  # TODO: Create Association Tests
  describe "associations" do
    pending "Add association tests after other Models are made to #{__FILE__}"
  end
end
