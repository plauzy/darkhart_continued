game = Game.create(:name => "New Game")
pat = User.create(:name => 'Pat')

b1 = Blackcard.create(:content => "Where is my mind?")
round = Round.create(:game_id => game.id, :leader_id => pat.id, :round_num => 1, :blackcard_id => b1.id)

round.blackcard #Success

# Find user who is a leader for a given round
User.find(round.leader_id)

# -----------------------------------------------

ian = User.create(:name => 'Ian')
cass = User.create(:name => "Cassidy")

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

#See winner of a round, given you have an instance of that round...
winner = round.submissions.where(["round_id = ? and winner = ?", round.id, 'true']).first.playable_card.user
winner = Submission.where(["round_id = ? and winner = ?", round.id, 'true']).first.playable_card.user
