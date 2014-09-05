class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :round_id
      t.integer :cards_in_play_id
      t.boolean :winner, default: false
    end
  end
end
