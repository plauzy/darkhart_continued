require 'rails_helper'

RSpec.describe User, :type => :model do
  before :each do
    User.destroy_all
  end

  it 'Creating a new User adds a User object' do
    expect{User.new}.to change(User.count).by(1)
  end

end
