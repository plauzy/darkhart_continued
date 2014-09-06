class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name, limit:30, :unique => true

      t.timestamp
    end
  end
end
