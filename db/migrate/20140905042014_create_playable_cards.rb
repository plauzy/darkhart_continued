class CreatePlayableCards < ActiveRecord::Migration
  def change
    create_table :playable_cards do |t|
      t.integer :seat_id
      t.integer :whitecard_id
      t.boolean :submitted, default: false

      t.timestamps
    end
  end
end
