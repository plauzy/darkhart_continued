class Seat < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :playable_cards

  def user_id
    self.user_id
  end

  def name
    self.user.name
  end

  def email
    self.user.email
  end
end
