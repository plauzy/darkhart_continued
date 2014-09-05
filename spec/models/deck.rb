require 'rails_helper'

RSpec.describe Deck, :type => :model do
  before :each do
    Deck.destroy_all
  end

  it 'Creating a new Deck adds a Deck object' do
    expect{Deck.new}.to change(Deck.count).by(1)
  end

end
