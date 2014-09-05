class Submission < ActiveRecord::Base
  belongs_to :round
  belongs_to :cards_in_play
end
