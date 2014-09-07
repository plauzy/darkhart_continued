class PlayableCard < ActiveRecord::Base
  belongs_to :whitecard
  belongs_to :seat
  has_one :submission

  validates_presence_of :seat_id,:whitecard_id
end
