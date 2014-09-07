class Submission < ActiveRecord::Base
  belongs_to :round
  belongs_to :playable_card

  def owner
    self.playable_card.seat
  end
end
