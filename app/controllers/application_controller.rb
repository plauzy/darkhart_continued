class ApplicationController < ActionController::API

  def game_state
    round_num = params["round"] || 0
    game = GameGetter.new(params["game_id"], params["user_id"], round_num.to_i)
    render :json => game.game_state
  end

  def submit_card
    update = GameSetter.new(params["game_id"],params["user_id"],params["card_id"])
    game = GameGetter.new(params["game_id"], params["user_id"], update.recap_round_num)
    render :json => game.game_state
  end
end
