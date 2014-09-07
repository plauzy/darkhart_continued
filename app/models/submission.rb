class Submission < ActiveRecord::Base
  belongs_to :round
  belongs_to :playable_card

  validates_presence_of :playable_card_id,:round_id
end
