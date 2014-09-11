require 'rails_helper'

RSpec.describe Seat, :type => :model do
  before :each do
    Seat.destroy_all
    User.destroy_all
    Game.destroy_all
    @user = User.create(name:"Test User",password:"password")
    @game = Game.create(name:"Test Game")
  end

  it 'should add a seat to the database' do
    expect{Seat.create(user_id:@user.id,game_id:@game.id)}.to change{Seat.count}.by(1)
  end

  it 'should initialize the score to 0' do
    seat = Seat.create(user_id:@user.id,game_id:@game.id)
    expect(seat.score).to eq(0)
  end

  it 'should not add a seat to the database without a user' do
    expect{Seat.create(game_id:@game.id)}.to_not change{Seat.count}
  end

  it 'should not add a seat to the database without a game' do
    expect{Seat.create(user_id:@user.id)}.to_not change{Seat.count}
  end
end
