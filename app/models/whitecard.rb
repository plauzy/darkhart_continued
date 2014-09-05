class Whitecard < ActiveRecord::Base
  has_one :cards_in_play
  has_one :submission, through: :cards_in_play
end
