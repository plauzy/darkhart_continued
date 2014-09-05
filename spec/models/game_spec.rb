require 'rails_helper'

RSpec.describe Game, :type => :model do
  before :each do
    Game.destroy_all
  end

  it 'Creating a new Game adds a Game object' do
    expect{Game.create()}.to change{Game.count}.by(1)
  end

end
