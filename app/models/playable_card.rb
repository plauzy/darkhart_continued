class PlayableCard < ActiveRecord::Base
  belongs_to :whitecard
  belongs_to :seat
  has_one :submission
end
