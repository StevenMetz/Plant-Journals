class CreateSharedJournals < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_journals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plant_journal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
