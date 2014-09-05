class CreateRound < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :leader_id
      t.integer :round_num
      t.integer :blackcard_id
    end
  end
end


