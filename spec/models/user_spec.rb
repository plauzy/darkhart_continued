require 'rails_helper'

RSpec.describe User, :type => :model do
  before :each do
    User.destroy_all
  end

  it 'should add a User to the database' do
    expect{User.create(name:'Brooks',password:"password")}.to change{User.count}.by(1)
  end

  it 'should not add a user to the database' do
    expect{User.create()}.to_not change{User.count}
  end

end
