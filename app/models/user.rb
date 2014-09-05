class User < ActiveRecord::Base
  belongs_to :game
  has_many :white_cards, alias: "Hand"
  has_many :won_rounds, :class_name => :round, :foreign_key => "round_id"
end
