require 'rails_helper'

RSpec.describe Submission, :type => :model do
  before :each do
    User.delete_all
    Game.delete_all
    Seat.delete_all
    PlayableCard.delete_all
    Round.delete_all
    Whitecard.delete_all
    Blackcard.delete_all
    Submission.delete_all
    @user = User.create(name:"Test User",password:"password")
    @game = Game.create(name:"Test Game")
    @seat = Seat.create(user_id:@user.id,game_id:@game.id)
    @whitecard = Whitecard.create(content:"Test White Card")
    @blackcard = Blackcard.create(content:"Test Black Card")
    @playable_card = PlayableCard.create(seat_id:@seat.id,whitecard_id:@whitecard.id)
    @round = Round.create(leader_id:@seat.id,round_num:41342,blackcard_id:@blackcard.id,game_id:@game.id)
  end

  it 'should add a submission to the database' do
    expect{Submission.create(round_id:@round.id,playable_card_id:@playable_card.id)}.to change{Submission.count}.by(1)
  end

  it 'should initialize winner status to false' do
    submission = Submission.create(round_id:@round.id,playable_card_id:@playable_card.id)
    expect(submission.winner).to be(false)
  end

  it 'should not add a submission without a card in play' do
    expect{Submission.create(round_id:@round.id)}.to_not change{Submission.count}
  end

  it 'should not add a submission without a round' do
    expect{Submission.create(playable_card_id:@playable_card.id)}.to_not change{Submission.count}
  end
end
