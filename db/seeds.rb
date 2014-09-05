game = Game.create(:name => "New Game")
pat = User.create(:name => 'Pat')

b1 = Blackcard.create(:content => "Where is my mind?")
round = Round.create(:game_id => game.id, :leader_id => pat.id, :round_num => 1, :blackcard_id => b1.id)

round.blackcard #Success

# -----------------------------------------------

ian = User.create(:name => 'Ian')
cass = User.create(:name => "Cassidy")

w1 = Whitecard.create(:content => "meow")
w2 = Whitecard.create(:content => "bark")
w3 = Whitecard.create(:content => "ribbet")

cip1 = CardsInPlay.create(:user_id => ian.id, :game_id => game.id, :whitecard_id => w1.id)
cip2 = CardsInPlay.create(:user_id => ian.id, :game_id => game.id, :whitecard_id => w2.id)
cip3 = CardsInPlay.create(:user_id => cass.id, :game_id => game.id, :whitecard_id => w3.id)

cip1.user #success
cip1.whitecard #Success
ian.cards_in_play #Success
cass.cards_in_play.first.whitecard #Success
# -------------------------------------------------

# s1 = Submission.create(:round_id => round.id, :cards_in_play_id => cip1.id)
s2 = Submission.create(:round_id => round.id, :cards_in_play_id => cip2.id)
s3 = Submission.create(:round_id => round.id, :cards_in_play_id => cip3.id)

round.submissions #Success
s1.round #Success
s2.round #Success

s2.winner = true
s2.save

#see winner of a round, given you have an instance of that round...
winner = round.submissions.where(["round_id = ? and winner = ?", round.id, true])




