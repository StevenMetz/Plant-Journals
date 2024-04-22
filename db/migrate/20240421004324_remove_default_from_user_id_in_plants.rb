class RemoveDefaultFromUserIdInPlants < ActiveRecord::Migration[7.1]
  def change
    change_column_default :plants, :user_id, from: 15, to: nil
  end
end
