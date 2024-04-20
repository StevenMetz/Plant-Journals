require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Validations" do

    it "Is a valid User" do
      user = User.new(
        name: "Steven",
        email: "test@test.com",
        password: "password",
        password_confirmation: "password"
      )

      expect(user).to be_valid
    end

    it "Should require an email" do
      user = User.new(
        name: "Steven",
        email: nil,
        password: "password",
        password_confirmation: "password"
      )
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

end
