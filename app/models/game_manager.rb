module GameManager
  extend self
  def new_user(name)
    new_user = User.create(name)
    return new_user.id
  end

  def new_game(*user_ids)
    game_users = user_ids.map { |user_id| user = User.find_by_id(user_id) }
    seats = populate_seats(game_users)
    # deal_cards_to_seats(seats)
  end

  # private

  def populate_seats(game_users)
    game_users.seat(Seat.create)
    new_game = Game.create
    new_game.seats << seats
    new_game.save
    return seats
  end

  def deal_cards_to_seats(seats)
    seats.each do |seat|
      10.times do
        PlayableCard.create(seat_id: seat.id, whitecard_id: random_whitecard)
      end
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
