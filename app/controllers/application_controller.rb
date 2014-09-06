class ApplicationController < ActionController::API
  respond_to :json
  def get_round
    #if round is complete, return round recap and id of current round.
    #elsif round is in progress, return data necessary for card submission:
      #if user is leader && all white cards submitted, returns black card and white cards to be evaluated.
      #elsif user is leader && white cards ! submitted, returns stall message.
      #elsif user is a player, return black card for consideration and current hand.
      #else player has already submitted a card, return error message.
    render json: {content:"Hello World"}
  end
  def submit_card
    #if user is leader, recieve their chosen whitecard.
    #elsif user is a player, recive their whitecard for consideration by leader.
  end
end