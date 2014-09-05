class Deck < ActiveRecord::Base
  has_many :white_cards
  has_many :black_cards
end
