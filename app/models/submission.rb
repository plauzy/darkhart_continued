class Submission < ActiveRecord::Base
  belongs_to :round
  belongs_to :playable_card

  validates_presence_of :playable_card_id,:round_id

  def owner_seat
    self.playable_card.seat
  end

  def owner_seat_id
    self.playable_card.seat.id
  end

  def owner_user_id
    self.playable_card.seat.user_id
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

  def owner_email
    self.playable_card.seat.user.email
  end

  def email
    self.playable_card.seat.user.email
  end
end
