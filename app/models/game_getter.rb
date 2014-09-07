class GameGetter
  attr_reader :current_round, :game, :seat

  def initialize(seat_id, round = 0)
    @seat = Seat.find_by_id(seat_id)
    @game = @seat.game
    if round == 0
      @round = Helper.current_round(@game)
    else
      @round = @game.rounds.where(round_num: round)
    end
  end

  # def game_state(round = @current_round)
  #   state = { header: build_header }
  #   if seat doesn't have a turn.
  #     state.body = build_no_turn



  #   return state
  # end

  def round_active?
    # if @current_round.submissions.where(winner: true)
    # end

  end
end
