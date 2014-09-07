# module TestDataImporter
#   def self.import

#     4.times do
#       FactoryGirl.create(:user)
#     end

#     game = FactoryGirl.create(:game)
#     users = User.all[0..3]

#     whitecards = Whitecard.all.to_a
#     blackcards = Blackcard.all.to_a

#     #cards dealt to users
#     4.times do
#       seat = FactoryGirl.create(:seat, user: users.pop, game: game )
#       4.times do
#         FactoryGirl.create(:playable_card, whitecard: whitecards.pop, seat: seat)
#       end
#     end

#     #round initiated
#     round = FactoryGirl.create(:round, game: game, blackcard: blackcards.pop)


#   end
# end

# TestDataImporter.import

module TestDataImporter
  def self.import

    4.times do
      FactoryGirl.create(:user)
    end

    game = FactoryGirl.create(:game)
    users = User.all[0..3]

    whitecards = Whitecard.all.to_a
    blackcards = Blackcard.all.to_a
    seats = []

    #cards dealt to users
    4.times do |i|
      seats << FactoryGirl.create(:seat, user: users.pop, game: game )
      4.times do
        FactoryGirl.create(:playable_card, whitecard: whitecards.pop, seat: seats[i])
      end
    end


    4.times do |i|
      leader_id = seats.last.id
      round = FactoryGirl.create(:round, game: game, blackcard: blackcards.pop, round_num: i+1, leader_id: leader_id)
      submissions = []

      3.times do |i|
        seat = seats[i]
        playable_cards = seat.playable_cards.to_a
        card_to_submit = playable_cards.pop

        submissions <<  FactoryGirl.create(:submission, playable_card: card_to_submit, round: round)
        card_to_submit.submitted = true
        card_to_submit.save!
      end

      chosen_sub = submissions.sample
      chosen_sub.winner = true
      chosen_sub.save!

      seats.rotate!
    end

    #round 5

    leader_id = seats.last.id
    round = FactoryGirl.create(:round, game: game, blackcard: blackcards.pop, round_num: 5, leader_id: leader_id)
    submissions = []

    2.times do |i|
      seat = seats[i]
      playable_cards = seat.playable_cards.to_a
      card_to_submit = playable_cards.pop

      submissions << FactoryGirl.create(:submission, playable_card: card_to_submit, round: round)
      card_to_submit.submitted = true
      card_to_submit.save!
    end





    #round 2


  end
end

TestDataImporter.import
