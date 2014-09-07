class ApplicationController < ActionController::API

  def game_state

    game = GameGetter.new()
    p params["user_id"]
    p params["game_id"]
    p params["round_id"]
  end

end
