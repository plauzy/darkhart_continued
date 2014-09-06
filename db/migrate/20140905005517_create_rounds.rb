class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :leader_id
      t.integer :blackcard_id
      t.integer :round_num
    end
  end
end


