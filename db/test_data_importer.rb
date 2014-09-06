module TestGameImporter
  def self.import

    4.times do 
      FactoryGirl.create(:user)
    end

    game = FactoryGirl.create(:game)
    users = User.all[0..3]

    whitecards = Whitecard.all.to_a
    blackcards = Blackcard.all.to_a 

    #cards dealt to users
    4.times do 
      seat = FactoryGirl.create(:seat, user: users.pop, game: game )
      4.times do 
        FactoryGirl.create(:playable_card, whitecard: whitecards.pop, seat: seat)
      end
    end

    #round initiated
    round = FactoryGirl.create(:round, game: game, blackcard: blackcards.pop)


  end
end

TestGameImporter.import


# user = FactoryGirl.create(:user)
# game = FactoryGirl.create(:game)
# seat = FactoryGirl.create(:seat, user: User.all.sample, game: game )
# whitecard = FactoryGirl.create(:whitecard)

# playable_card = FactoryGirl.create(:playable_card, whitecard: whitecard, seat: seat)

# blackcard = FactoryGirl.create(:blackcard)
# round = FactoryGirl.create(:round, game: game, blackcard: blackcard)
# submission = FactoryGirl.create(:submission, round: round, playable_card: playable_card)