class Scores < ActiveRecord::Migration
  def change
    add_column :seats, :score, :integer, default: 0
  end
end
