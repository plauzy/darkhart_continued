class Whitecard < ActiveRecord::Base
  has_one :playable_card
  has_one :submission, through: :playable_card
end
