class GameSetter
  def initialize(seat_id)
    @seat = Seat.find_by_id(seat_id)
    @game = @seat.game
  end

  def current_round(game)
    Round.find(game.current_round)
  end

  def make_submission(playable_card) #Make sure View checks that a user can only submit ONCE per round
    submission = Submission.create(playable_card_id: playable_card.id, round_id: @round.id)
    playable_card.submitted = true
    playable_card.save
    check_if_all_cards_submitted
  end

  def round_leader_choose_winner(winning_submission)
    winning_submission.winner = true
    winning_submission.save
  end

  private

  def check_if_all_cards_submitted
    if @submissions.length == @game.seats.length-1
      prompt_round_leader_for_decision
    else
      false
    end
  end

end



#   def tell_players_winning_card
#     return @submissions.select{|card| card.winner == true }.first
#   end


#   def prompt_round_leader_for_decision #this method fires off action to show blackcard holder the sbumissions
#     return @submissions
#   end






