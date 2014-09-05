require 'rails_helper'

RSpec.describe WhiteCard, :type => :model do
  before :each do
    WhiteCard.destroy_all
  end

  it 'Creating a new WhiteCard adds a WhiteCard object' do
    expect{WhiteCard.new}.to change(WhiteCard.count).by(1)
  end

end
