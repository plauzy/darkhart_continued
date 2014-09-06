class Seat < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :playable_cards
end
