FactoryGirl.define do 
  factory :game do 
    name {Faker::Company.name}
  end
end