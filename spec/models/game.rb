require 'rails_helper'

RSpec.describe Game, :type => :model do
  before :each do
    Game.destroy_all
  end

  it 'Creating a new game adds a game object' do
    expect{Game.new}.to change(Game.count).by(1)
  end

end
