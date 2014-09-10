require 'rails_helper'

RSpec.describe Round, :type => :model do
  before :each do
    Game.destroy_all
    Round.destroy_all
    User.destroy_all
    Blackcard.destroy_all
    Whitecard.destroy_all
    Submission.destroy_all
    PlayableCard.destroy_all
    Seat.destroy_all
    @game = Game.create(name: "Test Game")
    @user = User.create(name: "test dummy",password:"password")
    @seat = Seat.create(user_id:@user.id, game_id: @game.id)
    @blackcard = Blackcard.create(content:"Test Black Card")
    @whitecard = Whitecard.create(content:"Test White Card")
    @playable_card = PlayableCard.create(seat_id: @seat.id,whitecard_id: @whitecard.id)
  end

  it 'should add a round to the databse' do
    expect{Round.create(game_id: @game.id, leader_id: @seat.id, blackcard_id: @blackcard.id, round_num: 5783)}.to change{Round.count}.by(1)
  end

  it 'should accept a submission' do
    round = Round.create(game_id: @game.id, leader_id: @seat.id, blackcard_id: @blackcard.id, round_num: 5783)
    expect{Submission.create(round_id: round.id, playable_card_id:@playable_card.id)}.to change{round.submissions.count}.by(1)
  end

  it 'should not create a round without a black card' do
    expect{Round.create(game_id: @game.id, leader_id: @seat.id,  round_num: 5783)}.to_not change{Round.count}
  end

  it 'should not create a round without a game' do
    expect{Round.create(leader_id: @seat.id, blackcard_id: @blackcard.id, round_num: 5783)}.to_not change{Round.count}
  end

  it 'should not create a round without a leader' do
    expect{Round.create(game_id: @game.id, blackcard_id: @blackcard.id, round_num: 5783)}.to_not change{Round.count}
  end

  it 'should not create a round without a round number' do
    expect{Round.create(game_id: @game.id, leader_id: @seat.id, blackcard_id: @blackcard.id)}.to_not change{Round.count}
  end

end
