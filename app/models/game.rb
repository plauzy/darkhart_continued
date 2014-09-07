class Game < ActiveRecord::Base
  has_many :seats
  has_many :users, through: :seats
  has_many :rounds

  validates_presence_of :name
end
