require 'rails_helper'

RSpec.describe Game, :type => :model do
  before :each do
    Game.destroy_all
    Seat.destroy_all
    User.destroy_all
    Round.destroy_all
    Blackcard.destroy_all
    @user = User.create(name:"Test User",password:"password")
    @blackcard = Blackcard.create(content:"Test black card")
  end

  it 'should add a game to the database' do
    expect{Game.create(name:'Test Game')}.to change{Game.count}.by(1)
  end

  it 'should initialize the current round to 1' do
    game = Game.create(name:'Test Game')
    expect(game.round_num).to eq(1)
  end

  it 'should not add a game to the database without a name' do
    expect{Game.create()}.to_not change{Game.count}
  end

  it 'should accept a user to a seat' do
    game = Game.create(name:'Test Game')
    expect{Seat.create(user_id:@user.id,game_id:game.id)}.to change{game.seats.count}.by(1)
  end

  it 'should accept a round' do
    game = Game.create(name:'Test Game')
    seat = Seat.create(user_id:@user.id,game_id:game.id)
    expect{Round.create(leader_id:seat.id,round_num:23420342,blackcard_id:@blackcard.id,game_id:game.id)}.to change{game.rounds.count}.by(1)
  end

end
