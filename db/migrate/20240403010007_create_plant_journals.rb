class CreatePlantJournals < ActiveRecord::Migration[7.1]
  def change
    create_table :plant_journals do |t|
      t.string :title
      t.text :description
      t.string :likes
      t.string :dislikes
      t.string :water_frequency
      t.string :temperature
      t.string :sun_light_exposure

      t.timestamps
    end
  end
end
