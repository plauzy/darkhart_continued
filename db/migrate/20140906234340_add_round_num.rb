class AddRoundNum < ActiveRecord::Migration
  def change
    add_column :games, :round_number, :integer, default: 1
  end
end
