class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_one :black_card
end
