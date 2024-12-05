require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe "validations" do
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:message) }
  end

  describe "Associations" do
    it {should belong_to(:user)}
  end
end
