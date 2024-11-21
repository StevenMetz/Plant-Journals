require 'rails_helper'

RSpec.describe Plant, type: :model do
  describe "associations" do
    it "has and belongs to many plant journals" do
      should have_and_belong_to_many(:plant_journals)
    end

    it "belongs to a user" do
      should belong_to(:user)
    end
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user_id) }
  end

  describe "relationships" do
    let(:user) { create(:user) }
    let(:plant) { create(:plant, user: user) }
    let(:plant_journal) { create(:plant_journal, user: user) }

    it "can be added to a plant journal" do
      plant_journal.plants << plant
      expect(plant.plant_journals).to include(plant_journal)
    end

    it "can be removed from a plant journal" do
      plant_journal.plants << plant
      plant_journal.plants.delete(plant)
      expect(plant.plant_journals).not_to include(plant_journal)
    end

    it "can belong to multiple plant journals" do
      journal1 = create(:plant_journal, user: user)
      journal2 = create(:plant_journal, user: user)

      journal1.plants << plant
      journal2.plants << plant

      expect(plant.plant_journals.count).to eq(2)
      expect(plant.plant_journals).to include(journal1, journal2)
    end
  end
end
