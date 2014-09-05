class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :round_id
      t.integer :playable_card_id
      t.boolean :winner, default: false
    end
  end
end
