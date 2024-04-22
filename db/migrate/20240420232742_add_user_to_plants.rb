class AddUserToPlants < ActiveRecord::Migration[7.1]
  def change
    add_reference :plants, :user, foreign_key: true, default: 15
    change_column_default :plants, :user_id, from: nil, to: 15
  end
end
