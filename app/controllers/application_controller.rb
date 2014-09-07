class ApplicationController < ActionController::API

  def game_state
    round = params["round"] || 0
    p "------------- #{round}"
    game = GameGetter.new(params["game_id"], params["user_id"], round.to_i)
    render :json => game.game_state
  end

end
