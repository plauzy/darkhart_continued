class GameGetter

  def initialize(seat_id)
    @seat = Seat.find_by_id(seat_id)
    @game = @seat.game
    @current_round = Helper.current_round(@game)
  end



  def reveal_black_card #make sure this returns an ordered list
    return @current_round.blackcard.content
  end

end
