module GameManager

  def new_user(name)
    new_user = User.create(name)
    return new_user.id
  end


  class GameMaker

    def initialize(user_ids, number_of_rounds)
      @current_game = Game.create
      @game_users = user_ids.map { |user_id| user = User.find_by_id(user_id) }
      @seats = populate_seats()
      deal_cards_to_seats()
      @rounds = make_rounds(number_of_rounds)
    end

    private

    def populate_seats()
      @game_users.each do |user|
        user.seats << Seat.create(game_id: @current_game.id)
        user.save
      end
    end

    def deal_cards_to_seats()
      @current_game.seats.each do |seat|
        10.times do
          PlayableCard.create(seat_id: seat.id, whitecard_id: random_whitecard.id)
        end
      end
    end

    def make_rounds(number_of_rounds)
      user_array = @current_game.seats.to_a
      for round_num in (1..number_of_rounds)
        new_round = Round.create( game_id: @current_game.id,
                                  leader_id: user_array.first,
                                  blackcard_id: random_blackcard.id,
                                  round_num: round_num)
        @current_game.rounds << new_round
        @current_game.save
        user_array.rotate!
      end
    end

    def random_whitecard #add validation to prevent duplicate cards and offset is a valid Whitecard
      offset = rand(1..(Whitecard.count))
      Whitecard.find(offset)
    end

    def random_blackcard #add validation to prevent duplicate cards and offset is valid blackcard
      offset = rand(1..(Blackcard.count))
      Blackcard.find_by_id(offset)
    end
  end
end
