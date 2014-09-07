module TestDataImporter
  def self.import

    5.times do
      FactoryGirl.create(:user)
    end

    user_ids = [User.find(1), User.find(2), User.find(3), User.find(4), User.find(5)]

    game = GameSkeleton.new(name = "Test", user_ids, 4).new_game

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

    #seat 1 and 2 have submitted cards, seats 4 and 5 need to submit

  end
end

TestDataImporter.import
