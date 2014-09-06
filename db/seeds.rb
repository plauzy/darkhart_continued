#Create Users
pat = User.create(:name => 'Pat')
ian = User.create(:name => 'Ian')
cass = User.create(:name =>"Cassidy")
brooks = User.create(:name => "Brooks")


#Initiate a game with a new round
game = Game.create(:name => "New Game")

s1 = Seat.create(:user_id => pat.id, :game_id => game.id)
s2 = Seat.create(:user_id => cass.id, :game_id => game.id)
s3 = Seat.create(:user_id => ian.id, :game_id => game.id)
s4 = Seat.create(:user_id => brooks.id, :game_id => game.id)

b1 = Blackcard.create(:content => "Where is my mind?")
round = Round.create(:game_id => game.id, :leader_id => s1.id, :round_num => 1, :blackcard_id => b1.id)


round.blackcard #Success

#to find which seat is a leader at any point in the round
Seat.find(round.leader_id)
Seat.find(round.leader_id).user



w1 = Whitecard.create(:content => "meow")
w2 = Whitecard.create(:content => "bark")
w3 = Whitecard.create(:content => "ribbet")


playable_card_1 = PlayableCard.create(:seat_id => s1.id, :whitecard_id => w1.id)
playable_card_2 = PlayableCard.create(:seat_id => s1.id, :whitecard_id => w2.id)
playable_card_3 = PlayableCard.create(:seat_id => s2.id, :whitecard_id => w3.id)

playable_card_1.seat.game 
playable_card_1.whitecard #Success

s1.playable_cards #Success
s1.playable_cards.first.whitecard #Success
# -------------------------------------------------

submission1 = Submission.create(:round_id => round.id, :playable_card_id => playable_card_2.id)
submission2 = Submission.create(:round_id => round.id, :playable_card_id => playable_card_3.id)

round.submissions #Success
submission1.round #Success
submission1.playable_card.whitecard
submission1.playable_card.user

submission1.winner = true
submission1.save

round = Round.find(round.id)

#see winner of a round, given you have an instance of that round...
winner = round.submissions.where(["round_id = ? and winner = ?", round.id, 'true']).first
winner = Submission.where(["round_id = ? and winner = ?", round.id, 'true']).first.playable_card.seat
#get whitecard of winner
winner.playable_card.whitecard


