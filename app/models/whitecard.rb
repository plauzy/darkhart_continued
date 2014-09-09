class Whitecard < ActiveRecord::Base
  has_one :playable_card
  has_one :submission, through: :playable_card

  validates_presence_of :content
end
