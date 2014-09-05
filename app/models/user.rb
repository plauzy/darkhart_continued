class User < ActiveRecord::Base
  has_many :scores
  has_many :games, through: :scores

  has_many :playable_cards
end
