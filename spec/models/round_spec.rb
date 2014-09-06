require 'rails_helper'

RSpec.describe Round, :type => :model do
  before :each do
    Game.destroy_all
    Round.destroy_all
    User.destroy_all
    Blackcard.destroy_all
    game = Game.create()
    user = User.create(name: "test dummy")
    Blackcard
  end

  it 'Creating a new Round adds a Round object' do

    expect{Round.create(game_id: game.id, )}.to change{Round.count}.by(1)
  end

      t.integer :leader_id
      t.integer :round_num
      t.integer :blackcard_id
end
