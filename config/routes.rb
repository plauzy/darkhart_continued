Rails.application.routes.draw do
  get '/api/users/:user_id' => 'application#' # List of all games user is in.
  post '/api/users/:user_id' => 'application#' # Create a new user

  get '/api/games/:game_id' => 'application#active_games'# Returns status of a game
  post '/api/games/:game_id' => 'application#' # Creates new game

  get '/api/games/:game_id/rounds/:round_id' => 'application#get_round' # Round data
  put '/api/games/:game_id/rounds/:round_id' => 'application#submit_card' # Send in chosen card
end
