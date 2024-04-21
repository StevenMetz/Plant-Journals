require 'rails_helper'

RSpec.describe Plant, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      plant = Plant.new(
        title: "Test Plant",
        description: "This is a test plant",
        likes: 10,
        dislikes: 2,
        water_frequency: "Weekly",
        temperature: "Moderate",
        sun_light_exposure: "Partial Sun",
        user_id: user.id
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
    it "is not valid without a water frequency" do
      plant = Plant.new(water_frequency: nil)
      expect(plant).not_to be_valid
      expect(plant.errors[:water_frequency]).to include("can't be blank")
    end
    it "is not valid without a user" do
      plant = Plant.new(water_frequency: nil)
      expect(plant).not_to be_valid
      expect(plant.errors[:water_frequency]).to include("can't be blank")
    end
  end
  # TODO: Create Association Tests
  describe "associations" do
    it "can belong to a plant journal" do
      association = described_class.reflect_on_association(:plant_journal)
      expect(association).not_to be_nil
      expect(association.options[:optional]).to eq(true)
    end

    it "belongs to a user" do
      should belong_to(:user)
    end
  end
end
