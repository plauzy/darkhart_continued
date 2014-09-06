class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :user_id
      t.integer :game_id
    end
  end
end
