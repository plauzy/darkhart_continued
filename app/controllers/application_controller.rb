class ApplicationController < ActionController::API

  respond_to :json

  #post '/api/games/:game_id'
  def new_game
    #create new game, start it at round 1
    player_ids = JSON.decode(params[:players]).map{|player| player["player_id"]}
    new_game = GameManager::GameSetup.new(params[:game_name], player_ids)
    render json: {game: new_game, redirect: ""}, status: :ok

  end

  #get '/api/games/:game_id/rounds/:round_id'
  def get_round_for_user
    #all needed data
    player_id = params["authentication"]
    game_id = params[:game_id]
    round = Round.find(params[:round_id])
    seat = Seat.where(["user_id = '?' and game_id = '?'", player_id, game_id])[0]
    all_cards = seat.playable_cards
    playable_cards = cards.select { |card| card.submitted == false }
    hash = {}
    hash["round"] = round.id
    hash["leader"] = {}
    hash["leader"]["leader?"] = (seat.id == round.leader_id)
    hash["leader"]["blackcard_content"] = round.blackcard.content

    #if round is complete, return round recap and id of current round.
    if # round is not current
      hash["active"] = false
      hash["losing_submissions"] = []
      round.submissions.each do |submission| #do we need submission_id?
        hash["losing_submissions"] << {player_name:submission.playable_card.seat.user.name,player_score:submission.playable_card.seat.score,submission_id:submission.id,submission_content:submission.playable_card.whitecard.content} if !submission.winner
        hash["winning_submissions"] = {player_name:submission.playable_card.seat.user.name,player_score:submission.playable_card.seat.score,submission_id:submission.id,submission_content:submission.playable_card.whitecard.content} if submission.winner
      end
    elsif # round is current and user is leader # assuming the leader is viewing after all cards are submitted
      hash["active"] = true
      hash["submissions"] = []
      round.submissions.each do |submission|
        hash["submissions"] << {submitted?:true, player_name:submission.playable_card.seat.user.name,player_score:submission.playable_card.seat.score,submission_id:submission.id,submission_content:submission.playable_card.whitecard.content}
      end
    elsif # round is current and user has submitted card
      hash["active"] = true
      hash["players"] = []

      seats_submitted = round.submissions.map { |submission| submission.playable_card.seat}

      round.game.seats.each do |seat|
        hash["players"] << {player_name:seat.user.name,player_id:seat.user.id,submitted:seats_submitted.include?(seat.id)}
        #hash["players"] << {player_name:player.name,player_id:player.id,submitted:seats_submitted.include?(player.id)}
      end

      player_submission = round.submissions.select { |submission| submission.playable_card.seat.user.id == player_id }[0]

      hash["submission"] = {submitted?:true,submission_id:player_submission.id}
    else
    end

    #elsif round is in progress, return data necessary for card submission:
      #if user is leader && all white cards submitted, returns black card and
      #white cards to be evaluated.

      #up to view to decide whether all cards have been submitted
      #elsif user is leader && white cards ! submitted, returns stall message.
      hash["submissions"] =  [{ submitted?: true, player_name: "name", player_score: 1, submission_id: 1, submission_content: "Sentence"},
                      { submitted?: false, player_name: "name", player_score: 1 }] }



      #elsif user is a player, return black card for consideration and current hand.
      hash["player"] = players: [{playable_cards: playable_cards }]



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
