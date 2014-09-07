class Seat < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :playable_cards

  validates_presence_of :user_id,:game_id
end
