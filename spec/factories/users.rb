FactoryGirl.define do 
  factory :user do 
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.passwor}
  end
end