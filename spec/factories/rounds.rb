FactoryGirl.define do 
  factory :round do 
    game
    blackcard
    leader_id nil
    submitted false
  end
end