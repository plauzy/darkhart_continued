module TestDataImporter
  def self.import

    # 5.times do
    #   FactoryGirl.create(:user)
    # end

    User.create(name: "Brooks Riley", email: "brooksroley@gmail.com", password: "password" )
    User.create(name: "Chandler Smith", email: "chandlerhsmithdev@gmail.com", password: "password" )
    User.create(name: "Cassidy Clawson", email: "cassidyclawson@gmail.com", password: "password" )
    User.create(name: "Ian Bui", email: "thinkbui@gmail.com", password: "password" )
    User.create(name: "Pat Lauer", email: "plauer411@gmail.com", password: "password" )


    user_ids = [User.find(1), User.find(2), User.find(3), User.find(4), User.find(5)]

    game = GameSkeleton.new(name = "Mule Deer Rules", user_ids, 4).new_game


    #each user besides blackcard submits card each round for 2 rounds
    2.times do |i|
      round = Round.find_by_round_num(i+1)
      seats = game.seats


      submissions = []
      seats.each do |seat|
        unless round.leader_id == seat.id
          playable_cards = seat.playable_cards.where("submitted = false").to_a
          playable_card = playable_cards.pop
          submissions << FactoryGirl.create(:submission, playable_card: playable_card, round: round)
          playable_card.submitted = true
          playable_card.save!
          PlayableCard.create(seat_id: seat.id, whitecard_id: Helper.random_whitecard.id)
        end
      end
      chosen_submission = submissions.sample
      chosen_submission.winner = true
      chosen_submission.save!
      seat_owner = chosen_submission.owner_seat
      seat_owner.score+=1
      seat_owner.save!

      game.round_num+=1
      game.save!
    end

    #now seat 3 is blackcard leader, well have seat 1 and 2 submit
    round = Round.find_by_round_num(3)
    seats = game.seats
    2.times do |i|
      playable_cards = seats[i].playable_cards.where("submitted = false").to_a
      playable_card = playable_cards.pop
      FactoryGirl.create(:submission, playable_card: playable_card, round: round)
      playable_card.submitted = true
      playable_card.save!
    end

    playable_cards = seats[3].playable_cards.where("submitted = false").to_a
    playable_card = playable_cards.pop
    FactoryGirl.create(:submission, playable_card: playable_card, round: round)
    playable_card.submitted = true
    playable_card.save!

    #seat 1 and 2 have submitted cards, seats 4 and 5 need to submit

  end
end

TestDataImporter.import
