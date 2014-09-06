module GameManager
  extend self
  def new_user(name)
    new_user = User.create(name)
    return new_user.id
  end

  def new_game(*user_ids)
    new_game = Game.create
    game_users = user_ids.map { |user_id| user = User.find_by_id(user_id) }
    populate_seats(new_game, game_users)
    deal_cards_to_seats(new_game)
    return new_game
  end

  # private

  def populate_seats(new_game, game_users)
    game_users.each do |user|
      user.seats << Seat.create(game_id: new_game.id)
      user.save
    end
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
