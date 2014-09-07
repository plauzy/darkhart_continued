class ApplicationController < ActionController::API

  def game_state
    p "CONTROLLER ------------- #{params["round_num"]}"
    round = params["round_num"] || 0
    game = GameGetter.new(params["game_id"], params["user_id"], round)
    render :json => game.game_state
  end

end
