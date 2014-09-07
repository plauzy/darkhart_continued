class Seat < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :playable_cards

  def name
    self.user.name
  end

  def email
    self.user.email
  end
end
