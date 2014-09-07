class Submission < ActiveRecord::Base
  belongs_to :round
  belongs_to :playable_card

  def owner_seat
    self.playable_card.seat
  end

  def card_content
    self.playable_card.whitecard.content
  end

  def owner_name
    self.playable_card.seat.user.name
  end

  def owner_score
    self.playable_card.seat.score
  end

  def email
    self.playable_card.seat.user.email
  end
end
