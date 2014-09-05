class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :blackcard
end
