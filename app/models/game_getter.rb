require 'pp'
class GameGetter
  attr_reader :current_round, :game, :seat

  def initialize(seat_id, round = 0)
    @seat = Seat.find_by_id(seat_id)
    @game = @seat.game
    if round == 0
      @round = Helper.current_round(@game)
    else
      @round = @game.rounds.where(round_num: round)[0]
    end

    @submissions = @round.submissions
    @game_seats = @game.seats
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

    pp @state
  end

  private

# Conditionals & Helpers ----------------

  def round_active?
    @submissions.where(winner: true)[0] ? false : true
  end

  def leader?
    @round.leader_id == @seat.id
  end

  def get_leader
    Seat.find_by_id(@round.leader_id)
  end

  def waiting_on?
    ineligible_seats = @submissions.map { |sub| sub.owner_seat }
    ineligible_seats << get_leader
    @game_seats - ineligible_seats
  end

# Header Methods --------------

  def build_header
    @state["round"] = @round.round_num
    @state["active"] = round_active?
    @state["player_self"] = player_self
    @state["leader"] = leader_blackcard
  end

  def player_self
    { name: @seat.name,
      score: @seat.score,
      seat_id: @seat.id,
      cards: playable_cards }
  end

  def playable_cards
    cards = @seat.playable_cards.where(submitted: false).to_a
    cards.map do |card|
      { playable_card_id: card.id, content: card.whitecard.content }
    end
  end

  def leader_blackcard
    { leader?: leader?,
      blackcard_content: @round.blackcard.content }
  end

# Recap Methods ----------------

  def build_recap
    @state["losing_submissions"] = []
    @submissions.each do |sub|
      sub_details = { player_name: sub.owner_name,
                      player_score: sub.owner_score,
                      submission_content: sub.card_content }
      @state["losing_submissions"] << sub_details if sub.winner == false
      @state["winning_submission"] = sub_details if sub.winner == true
    end
  end

# Leader Methods ---------------

  def build_submissions
    @state.submissions = @submissions.map do |sub|
      { submitted?: true,
        player_name: sub.owner_name,
        player_score: sub.owner_score,
        submission_id: sub.id,
        submission_content: sub.card_content }
    end
  end
end

