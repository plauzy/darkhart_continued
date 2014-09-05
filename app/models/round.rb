class Round < ActiveRecord::Base
  belongs_to :game, counter_cache: :round_num
  belongs_to :blackcard
  has_many :submissions
end
