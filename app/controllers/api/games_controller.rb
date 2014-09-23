class Api::GamesController < ApplicationController
  def new_game
    user_ids = [params[:user_id]]
    params[:invite_ids].split(",").each { |id| user_ids << id }
    new_game = GameSkeleton.new(params[:game_name], user_ids, (params[:num_rounds] || 10)).new_game
    game = GameGetter.new(new_game.id, params[:user_id])
    render :json => game.game_state
  end

  def game_state
    round_num = params["round_num"] || 0
    puts "round num: #{round_num}"
    game = GameGetter.new(params["game_id"], params["user_id"], round_num.to_i)
    render :json => game.game_state
  end

  def submit_card
    update = GameSetter.new(params["game_id"],params["user_id"],params["card_id"])
    game = GameGetter.new(params["game_id"], params["user_id"], update.recap_round_num)
    render :json => game.game_state
  end

  def inventory
    inventory = GameInventory.new(params["user_id"])
    render :json => inventory.list
  end

  def game_recap
    recap = GameRecap.new(params["user_id"], params["game_id"])
    render :json => recap.recap
  end
end
