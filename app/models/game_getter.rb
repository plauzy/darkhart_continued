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

    @state = {}
  end

  def game_state
    build_header
    if round_active?

    elsif !round_active?
      build_recap
    end

    return @state
  end

  private

# Conditionals ----------------

  def round_active?
    @round.submissions.where(winner: true)[0] ? false : true
  end

# Header Methods --------------

  def build_header
    @state.round = @round.round_num
    @state.active = round_active?
    @state.player_self = player_self
    @state.leader = leader
  end

  def player_self
    { name: @seat.user.name,
      score: @seat.score,
      seat_id: @seat.id,
      cards: playable_cards }
  end

  def playable_cards
    @seat.playable_cards.where(submitted: false).to_a
  end

  def leader
    { leader?: @round.leader_id == @seat.id,
      blackcard_content: @round.blackcard.content }
  end

# Recap Methods ----------------

  def recap
    @state.losing_submissions = []
    @round.submissions.each |sub|
      sub_details = { player_name: sub.playable_card.seat.user.name,
                      player_score: sub.playable_card.seat.score,
                      submission_content: sub.playable_card.whitecard.content }
      @state.losing_submissions << sub_details if sub.winner == false
      @state.winning_submission << sub_details if sub.winner == true
    end
  end
end



