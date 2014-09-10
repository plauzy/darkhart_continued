require 'rails_helper'

RSpec.describe PlayableCard, :type => :model do
  before :each do
    PlayableCard.delete_all
    User.delete_all
    Seat.delete_all
    Game.delete_all
    Whitecard.delete_all
    @user = User.create(name:"Test User",password:"password")
    @game = Game.create(name:"Test Game")
    @seat = Seat.create(user_id:@user.id,game_id:@game.id)
    @whitecard = Whitecard.create(content:"Test white card")
  end

  it 'should add a card in play to the database' do
    expect{PlayableCard.create(seat_id:@seat.id,whitecard_id:@whitecard.id)}.to change{PlayableCard.count}.by(1)
  end

  it 'should initialize its submission status to false' do
    playable_card = PlayableCard.create(seat_id:@seat.id,whitecard_id:@whitecard.id)
    expect(playable_card.submitted).to be(false)
  end

  it 'should not add a card in play to the database without a seat' do
    expect{PlayableCard.create(whitecard_id:@whitecard.id)}.to_not change{PlayableCard.count}
  end

  it 'should not add a card in play to the database without a white card' do
    expect{PlayableCard.create(seat_id:@seat.id)}.to_not change{PlayableCard.count}
  end
end
