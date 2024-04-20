class AddPlantJournalToPlants < ActiveRecord::Migration[7.1]
  def change
    add_reference :plants, :plant_journal, foreign_key: true
  end
end
