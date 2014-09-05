require 'rails_helper'

RSpec.describe User, :type => :model do
  before :each do
    User.destroy_all
  end

  it 'Creating a new User adds a User object' do
    expect{User.create(name:'Brooks')}.to change{User.count}.by(1)
  end

  it 'Creating a new User without a name does not add user' do
    expect{User.create()}.to change{User.count}.by(0)
  end
end
