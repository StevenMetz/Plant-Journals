class SharedJournal < ApplicationRecord
  belongs_to :user
  belongs_to :plant_journal
end
