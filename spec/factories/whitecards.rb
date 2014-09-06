FactoryGirl.define do 
  factory :whitecard do 
    content {Faker::Company.catch_phrase}
  end
end