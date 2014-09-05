class CardsInPlay < ActiveRecord::Base
  belongs_to :whitecard
  belongs_to :user
end
