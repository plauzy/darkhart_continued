class Submission < ActiveRecord::Base
  belongs_to :round
  belongs_to :playable_card
end
