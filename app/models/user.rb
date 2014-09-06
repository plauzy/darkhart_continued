class User < ActiveRecord::Base
  has_many :seats
  has_many :games, through: :seats

  validates :name, presence: true

end
