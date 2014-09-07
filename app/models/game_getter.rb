class GameGetter
  attr_reader :current_round, :game, :seat

  def initialize(game_id, user_id, round = 0)
    @seat = Seat.where(["user_id = ? and game_id = ?", user_id, game_id]).first
    @game = @seat.game
    if round == 0 || (round > @game.total_rounds)
      @round = Helper.current_round(@game)[0]
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
    round_active? ? build_submissions : build_recap
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

  def need_submission?
    if leader?
      @submissions.to_a.length == @seats.to_a.length - 1 ? true : false
    else
      waiting_on?.include? @seat
    end
  end

# Header Methods --------------

  def build_header
    @state["game_id"] = @game.id
    @state["round"] = @round.round_num
    @state["active"] = round_active?
    @state["player_self"] = player_self
    @state["leader"] = leader_blackcard
    @state["need_submission?"] = need_submission?
  end

  def player_self
    { # user_id: @seat.user_id,
      seat_id: @seat.id,
      player_name: @seat.name,
      player_score: @seat.score,
      player_email: @seat.email,
      player_cards: playable_cards }
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
                      player_email: sub.email,
                      submission_content: sub.card_content }
      @state["losing_submissions"] << sub_details if sub.winner == false
      @state["winning_submission"] = sub_details if sub.winner == true
    end
  end

# Leader Methods ---------------

  def build_submissions
    @state["submissions"] = @submissions.map do |sub|
      { player_name: sub.owner_name,
        player_score: sub.owner_score,
        player_email: sub.email,
        submission_id: sub.id,
        submission_content: sub.card_content }
    end
    if waiting_on?
      @state["missing_submissions"] = waiting_on?.select { |s| s != @seat }.map do |seat|
        { player_name: seat.name,
          player_score: seat.score,
          player_email: seat.email }
      end
    end
  end
end


