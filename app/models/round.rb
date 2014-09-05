class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :blackcard
  has_many :submissions
end
