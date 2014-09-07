Rails.application.routes.draw do

  get 'api/users/:user_id' => 'application#user_state' # Returns all games the user is in.
  post 'api/users/:user_id/games' => 'application#new_game' # Creates new game and returns game_state

  get 'api/users/:user_id/games/:game_id' => 'application#game_state'
  get 'api/users/:user_id/games/:game_id/rounds/:round' => 'application#game_state'

  get 'api/users/:user_id/games/:game_id/cards/:card_id' => 'application#submit_card' # GET FOR TESTING ONLY
end
