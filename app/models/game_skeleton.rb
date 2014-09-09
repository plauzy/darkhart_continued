class GameSkeleton
  attr_reader :new_game

  def initialize(name="default", user_ids, number_of_rounds)
    @new_game = Game.create(name: name)
    @game_users = user_ids.map { |user_id| user = User.find_by_id(user_id) }
    populate_seats
    deal_cards_to_seats
    make_rounds(number_of_rounds)
    return @new_game.id
  end

  private

  def populate_seats
    @game_users.each do |user|
      user.seats << Seat.create(game_id: @new_game.id)
      user.save
    end
  end

  def deal_cards_to_seats()
    @new_game.seats.each do |seat|
      10.times do
        PlayableCard.create(seat_id: seat.id, whitecard_id: Helper.random_whitecard.id)
      end
    end
  end

  def make_rounds(number_of_rounds)
    user_array = @new_game.seats.to_a
    for round_num in (1..number_of_rounds)
      new_round = Round.create( game_id: @new_game.id,
        leader_id: user_array.first.id,
        blackcard_id: Helper.random_blackcard.id,
        round_num: round_num)
      @new_game.rounds << new_round
      @new_game.save
      user_array.rotate!
    end
  end
end
