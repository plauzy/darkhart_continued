class Game < ActiveRecord::Base
  has_many :seats
  has_many :users, through: :seats
  has_many :rounds

  validates_presence_of :name

  def total_rounds
    self.rounds.length
  end

  def active?
    # Checks if the last round in the game contains a winning submission.
    self.rounds.where(round_num: self.rounds.length)[0].submissions.where(winner: true)[0] ? false : true
  end
end
