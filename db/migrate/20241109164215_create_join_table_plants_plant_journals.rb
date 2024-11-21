class CreateJoinTablePlantsPlantJournals < ActiveRecord::Migration[7.1]
  def change
    create_join_table :plants, :plant_journals do |t|
      t.index [:plant_id, :plant_journal_id]
      t.index [:plant_journal_id, :plant_id]
    end
    remove_column :plants, :plant_journal_id
  end
end
