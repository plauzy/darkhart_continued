FactoryGirl.define do 
  factory :blackcard do 
    content {Faker::Hacker.say_something_smart}
  end
end