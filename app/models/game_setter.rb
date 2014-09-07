class GameSetter 

  def initialize(user_id, game_id)
    @seat = Seat.where(["user_id = ? and game_id = ?", user_id, game_id]).first
    @game = @seat.game
    @round_num = @game.current_round
    @round = Round.where(["round_num = ? and game_id = ?", @game.current_round, @game.id )[0]
    @submissions = @round.submissions
    @state = {}
  end

  def make_user_submission(playable_card)
    @submission = Submission.create(playable_card_id: playable_card.id, round_id: @round.id) unless playable_card.submitted == true
    playable_card.submitted = true 
    playable_card.save!
  end

  def choose_winner(winning_submission)
    winning_submission.winner = true
    winning_submission.save!

    increment_round 
    deal_new_card_to_seats
  end

  private

  def increment_round 
    @game.current_round+=1
    @game.save!
  end

  def deal_new_card_to_seats
    @game.seats.each do |seat|
      whitecard = Whitecard.all.sample
      seat.playable_cards << PlayableCard.create(whitecard_id: whitecard.id)
    end
  end

  def round_active?
    @submissions.where(winner: true)[0] ? false : true
  end

end

__END__

{authentication: [user_id],
game_id: 1,
submission_id: 1}

{authentication: [user_id],
game_id: 1, 
playable_card_id: 1}




  # def build_header
  #   @state["round"] = @round.round_num
  #   @state["active"] = round_active?
  #   @state["player_self"] = player_self
  #   @state["leader"] = leader_blackcard
  #   @state["need_submission?"] = need_submission?
  # end


  # def build_player_submission
  #   @state["authentication"] = @seat.user.id
  #   @seat["game_id"] = @game.id
  #   @seat["submission_id"] = @submission.id
  # end

  # def build_leader_submission 
  #   @state["authentication"] = @seat.user.id
  #   @seat["game_id"] = @game.id
  #   @seat
  # end




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






