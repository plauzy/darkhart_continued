Rails.application.routes.draw do
  get 'api/users/:user_id' => 'application#user_state' # Returns all games the user is in.
  get 'api/games/:game_id/users/:user_id/round/:round_id' => 'application#game_state' # Returns state of a game

  post 'api/games' => 'application#new_game' # Creates new game and returns game_state
  post 'api/games/:game_id/users/:user_id/cards/:card_id' => 'application#update_game' #Submits a card
end
