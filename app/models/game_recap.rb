class GameRecap < GameGetter
  def initialize(user_id, game_id)
    @seat = Seat.where(["user_id = ? and game_id = ?", user_id, game_id])[0]
    @game = @seat.game
    @rounds = @game.rounds.to_a
    @game_seats = @game.seats
    @recap = {}
  end

  def recap
    @recap = @rounds.map { |r| parse(r) }.compact
  end

  def parse(round)
    @round = round
    @submissions = round.submissions
    @winner = @submissions.where(winner: true)[0]

    rd_recap = {
      game_name: @game.name,
      round_num: round.round_num,
      active: round_active?,
      leader_id: round.leader_id,
      leader_name: get_leader.user.name,
      leader_email: get_leader.user.email,
      blackcard_content: round.blackcard.content
    }

    if @winner
      rd_recap[:winner_id] = @winner.owner_user_id
      rd_recap[:winner_email] = @winner.owner_email
      rd_recap[:winner_name] = @winner.owner_name
      rd_recap[:winner_whitecard] = @winner.card_content
    end

    rd_recap[:round_num] <= Helper.current_round(@game)[0].round_num ? rd_recap : nil
  end
end
