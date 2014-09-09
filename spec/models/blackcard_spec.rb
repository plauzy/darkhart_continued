require 'rails_helper'

RSpec.describe Blackcard, :type => :model do
  before :each do
    Blackcard.destroy_all
  end

  it 'should add a black card to the database' do
    expect{Blackcard.create(content:'Test')}.to change{Blackcard.count}.by(1)
  end

  it 'should not add a card to the database without content' do
    expect{Blackcard.create()}.to_not change{Blackcard.count}
  end

end
