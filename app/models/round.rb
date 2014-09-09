class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :blackcard
  has_many :submissions

  validates_presence_of :blackcard_id,:game_id,:round_num,:leader_id
end
