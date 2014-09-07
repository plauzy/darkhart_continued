class GameSetter


  def initialize(game_id, user_id, card_id)
    @seat = Seat.where(["user_id = ? and game_id = ?", user_id, game_id]).first
    @game = @seat.game
    @round = Round.where(["round_num = ? and game_id = ?", @game.round_num, @game.id]).first
    @submissions = @round.submissions

    if @seat.id == @round.leader_id
      winning_submission = Submission.find(card_id)
      choose_winner(winning_submission)
    else
      playable_card_submission = PlayableCard.find(card_id)
      make_user_submission(playable_card_submission)
    end
  end

  private

  def make_user_submission(playable_card)
    submission = Submission.create(playable_card_id: playable_card.id, round_id: @round.id) unless playable_card.submitted == true
    playable_card.submitted = true
    playable_card.save!
  end

  def choose_winner(winning_submission)
    winning_submission.winner = true
    winning_submission.save!

    winning_seat = winning_submission.owner_seat
    winning_seat.score+=1
    winning_seat.save!

    increment_round
    deal_new_card_to_seats
  end

  def increment_round
    @game.round_num+=1
    @game.save!
  end

  def deal_new_card_to_seats
    @game.seats.each do |seat|
      whitecard = Whitecard.all.sample
      seat.playable_cards << PlayableCard.create(whitecard_id: whitecard.id)
    end
  end
end


user = User.first
game = Game.first
GameSetter.new(game_id, user_id)
player3cards=Seat.find(3).playable_cards.where("submitted = false")


