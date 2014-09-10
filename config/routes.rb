Rails.application.routes.draw do
  # new game form
  post 'api/games' => 'api/games#new_game'
  # previous round recap
  get "/api/games/:game_id/rounds/:round_num" => 'api/games#game_state'
  # current game state
  get "/api/games/:game_id" => 'api/games#game_state'
  # makesubmission
  get "/api/games/:game_id/cards/:card_id" => 'api/games#submit_card'
  # make decision
  post "/api/games/:game_id/round/:round_id" => 'api/games#submit_card'

  get '/tool' => "devtool#index"
  root 'devtool#index'
end
