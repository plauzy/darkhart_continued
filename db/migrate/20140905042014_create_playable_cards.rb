class CreatePlayableCards < ActiveRecord::Migration
  def change
    create_table :playable_cards do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :whitecard_id
      t.boolean :playable, default: true

      t.timestamps
    end
  end
end
