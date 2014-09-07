class ApplicationController < ActionController::API

  def game_state
    round = params["round"] || 0
    game = GameGetter.new(params["game_id"], params["user_id"], round.to_i)
    render :json => game.game_state
  end

  def submit_card
    GameSetter.new(params["game_id"],params["user_id"],params["card_id"]).submit_card
    game = GameGetter.new(params["game_id"], params["user_id"])
    render :json => game.game_state
  end
end
