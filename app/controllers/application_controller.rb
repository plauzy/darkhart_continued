class ApplicationController < ActionController::API
  respond_to :json

  #post '/api/games/:game_id'
  def new_game
    #create new game, start it at round 1
    player_ids = JSON.decode(params[:players]).map{|player| player["player_id"]}
    new_game = GameManager::GameSetup.new(params[:game_name], player_ids)
    render json: {game: new_game, redirect: ""}, status: :ok

  end

  #get '/api/games/:game_id/rounds/:id'
  def get_round
    player_id = params["authentication"]
    game_id = params[:game_id]
    player_seat = Seat.where(["user_id = ? and game_id = ?", player_id, game_id)
    hash = {}
    hash["round"] = ?
    #if round is complete, return round recap and id of current round.
    hash["active"] = ?


    #elsif round is in progress, return data necessary for card submission:
      #if user is leader && all white cards submitted, returns black card and
      #white cards to be evaluated.

      #up to view to decide whether all cards have been submitted
      #elsif user is leader && white cards ! submitted, returns stall message.
      hash["leader"] = { leader?: true, blackcard_content: "Sentence" }
      player
      hash["submissions"] =  [{ submitted?: true, player_name: "name", player_score: 1, submission_id: 1, submission_content: "Sentence"},
                      { submitted?: false, player_name: "name", player_score: 1 }] }



      #elsif user is a player, return black card for consideration and current hand.
      hash["leader"] = { leader?: false, blackcard_content: "Sentence" }
      hash["player"] =



        { leader: { leader?: false, blackcard_content: "Sentence" },
        players: [{player_name: "name", player_id: 1, submitted: true/false}]
        submission: { submitted?: true, submission_id: 5 } # if submitted is true
      }

      #else player has already submitted a card, return error message.


    render json: hash.to_json
    # render json: {content:"Hello World"}
  end

  #get '/api/games/:game_id/rounds/current'
  def get_completed_round

  end

  def submit_card
    #if user is leader, recieve their chosen whitecard.
    #elsif user is a player, recive their whitecard for consideration by leader.
  end




end
