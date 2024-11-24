require 'rails_helper'

RSpec.describe Notification, type: :model do
  let (:user) {create :user}
  describe("Validations") do
    context "Validates required fields" do
      it "Requires a title" do
        notification = Notification.new(
          user_id: user.id,
          title: nil,
          message: "Hello",
          viewed: false,
          notification_type: 0
        )
        expect(notification).not_to be_valid
      end

      it "Requires a message" do
        notification = Notification.new(
        user_id: user.id,
        title: "nil",
        message: nil,
        viewed: false,
        notification_type: 0
      )
        expect(notification).not_to be_valid
      end

      it "Is a valid Notification" do
        notification = Notification.new(
          user_id: user.id,
          title: "Hello",
          message: "New Plant shared",
          viewed: false,
          notification_type: 0
        )

        expect(notification).to  be_valid
      end
    end

  end
  it {should belong_to(:user)}
end
