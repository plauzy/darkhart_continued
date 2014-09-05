class Round < ActiveRecord::Base
  belongs_to :game
  has_one :blackcard
end
