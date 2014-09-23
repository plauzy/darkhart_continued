class GameInventory
  def initialize(user_id)
    @user = User.find(user_id)
    @games = @user.games
    @game_inventory = []
  end

  def list
    game_inventory = @games.map { |game| parse(game) }
  end

  private

    def parse(game)
      round = Helper.current_round(game)[0]
      submissions = round.submissions
      seat = Seat.where(["user_id = ? and game_id = ?", @user.id, game.id])[0]
      leader = Seat.find(round.leader_id)
      { game_id: game.id,
        game_name: game.name,
        active: game.active?,
        current_round: round.round_num,
        need_submission: need_submission?(game, submissions, seat, round),
        leader_name: leader.name,
        leader_email: leader.email,
        blackcard_content: Blackcard.find(round.blackcard_id).content }
    end

    def need_submission?(game, submissions, seat, round)
      if leader?(round, seat)
        submissions.to_a.length == game.seats.to_a.length - 1 ? true : false
      else
        waiting_on?(game, submissions, seat, round).include? seat
      end
    end

    def waiting_on?(game, submissions, seat, round)
      ineligible_seats = submissions.map { |sub| sub.owner_seat }
      ineligible_seats << get_leader(round)
      game.seats - ineligible_seats
    end

    def get_leader(round)
      Seat.find_by_id(round.leader_id)
    end

    def leader?(round, seat)
      round.leader_id == seat.id
    end
end
