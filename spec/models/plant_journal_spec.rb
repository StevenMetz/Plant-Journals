require 'rails_helper'

RSpec.describe PlantJournal, type: :model do
  context "Associations" do
    it {should belong_to(:user)}
    it {should have_many(:plants)}
  end
end
