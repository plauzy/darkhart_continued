class GameGetter
  attr_reader :current_round, :game, :seat

  def initialize(seat_id, round = 0)
    @seat = Seat.find_by_id(seat_id)
    @game = @seat.game
    round == 0
      @round = Helper.current_round(@game)
    else
      @round = @game.rounds.where(round_num: round)
    end

    @submissions = @round.submissions.to_a
    @game_seats = @game.seats.to_a
    @state = {}
  end

# God Method -------------------

  def game_state
    build_header
    if round_active? && leader?

    elsif round_active?
      build_submissions
    else
      build_recap
    end

    return @state
  end

  private

# Conditionals & Helpers ----------------

  def round_active?
    @submissions.where(winner: true)[0] ? false : true
  end

  def leader?
    @round.leader_id == @seat.id
  end

  def waiting_on?
    leader_seat = seat.find_by_id(@round.leader_id)
    @game_seats.select do |seat|
      seat



    end

  end

# Header Methods --------------

  def build_header
    @state.round = @round.round_num
    @state.active = round_active?
    @state.player_self = player_self
    @state.leader = leader_blackcard
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

  def leader_blackcard
    { leader?: leader?,
      blackcard_content: @round.blackcard.content }
  end

# Recap Methods ----------------

  def recap
    @state.losing_submissions = []
    @submissions.each |sub|
      sub_details = { player_name: sub.playable_card.seat.user.name,
                      player_score: sub.playable_card.seat.score,
                      submission_content: sub.playable_card.whitecard.content }
      @state.losing_submissions << sub_details if sub.winner == false
      @state.winning_submission << sub_details if sub.winner == true
    end
  end

# Leader Methods ---------------

  def build_submissions
    @state.submissions = @submissions.map do |sub|
      seat_submission = {
        submitted?: true,
        player_name: sub.playable_card.seat.user.name,
        player_score: sub.playable_card.seat.score,
        submission_id: sub.id,
        submission_content: sub.playable_card.whitecard.content
      }
    # if @state.submissions.length < @game.seats.count
    #   @ga
    # end



end
