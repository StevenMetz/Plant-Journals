require 'rails_helper'

RSpec.describe SharedJournal, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:plant_journal) }
  end
end
