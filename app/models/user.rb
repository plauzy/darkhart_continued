class User < ActiveRecord::Base
  has_many :scores
  has_many :games, through: :scores

  has_many :cards_in_play
end
