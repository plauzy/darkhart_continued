module GameManager
  extend self
  def new_user(name)
    new_user = User.create(name)
    return new_user.id
  end

  def new_game(*user_ids)
    seats = populate_seats(*user_ids)
    deal_cards_to_seats(seats)
  end

  private

  def populate_seats(*user_ids)
    seats = user_ids.map { |user_id| seat = Seat.create(user_id: user_id) }
    new_game = Game.create
    new_game.seats << seats
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
