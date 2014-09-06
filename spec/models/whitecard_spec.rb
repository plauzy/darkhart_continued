require 'rails_helper'

RSpec.describe Whitecard, :type => :model do
  before :each do
    Whitecard.destroy_all
  end

  it 'Creating a new Whitecard adds a Whitecard object' do
    expect{Whitecard.create(content:'Test')}.to change{Whitecard.count}.by(1)
  end

end
