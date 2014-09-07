class GameSetter

  def initialize(user_id, game_id)
    @seat = Seat.where(["user_id = ? and game_id = ?", user_id, game_id]).first
    @game = @seat.game
    @round_num = @game.round_num
    @round = Round.where(["round_num = ? and game_id = ?", @game.round_num, @game.id]).first
    @submissions = @round.submissions
  end

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

  private

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
