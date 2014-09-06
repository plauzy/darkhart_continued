pat = User.create(:name => 'Pat')
ian = User.create(:name => 'Ian')
cass = User.create(:name => "Cassidy")
brooks = User.create(:name => "Brooks")
game = Game.create(:name => "New Game")

s1 = Seat.create(:user_id => pat.id, :game_id => game.id)
s2 = Seat.create(:user_id => cass.id, :game_id => game.id)
s3 = Seat.create(:user_id => ian.id, :game_id => game.id)
s4 = Seat.create(:user_id => brooks.id, :game_id => game.id)

#Round 1
b1 = Blackcard.create(:content => "Where is my mind?")
round = Round.create(:game_id => game.id, :leader_id => pat.id, :round_num => 1, :blackcard_id => b1.id)

round.blackcard #Success
User.find(round.leader_id)
# Find user who is a leader for a given round

# -----------------------------------------------


w1 = Whitecard.create(:content => "meow")
w2 = Whitecard.create(:content => "bark")
w3 = Whitecard.create(:content => "ribbet")


playable_card_1 = PlayableCard.create(:user_id => ian.id, :game_id => game.id, :whitecard_id => w1.id)
playable_card_2 = PlayableCard.create(:user_id => ian.id, :game_id => game.id, :whitecard_id => w2.id)
playable_card_3 = PlayableCard.create(:user_id => cass.id, :game_id => game.id, :whitecard_id => w3.id)

playable_card_1.user #success
playable_card_1.whitecard #Success
ian.playable_cards #Success
cass.playable_cards.first.whitecard #Success
# -------------------------------------------------

s1 = Submission.create(:round_id => round.id, :playable_card_id => playable_card_2.id)
s2 = Submission.create(:round_id => round.id, :playable_card_id => playable_card_3.id)

round.submissions #Success
s1.round #Success
s1.playable_card.whitecard
s1.playable_card.user

s1.winner = true
s1.save

#see winner of a round, given you have an instance of that round...
winner = round.submissions.where(["round_id = ? and winner = ?", round.id, 'true']).first.playable_card.user
winner = Submission.where(["round_id = ? and winner = ?", round.id, 'true']).first.playable_card.user
#get whitecard of winner
winner.playable_card.whitecard
