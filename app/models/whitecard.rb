class Whitecard < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
end
