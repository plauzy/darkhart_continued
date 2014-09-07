require 'rails_helper'

RSpec.describe Whitecard, :type => :model do
  before :each do
    Whitecard.destroy_all
  end

  it 'should add a white card to the database' do
    expect{Whitecard.create(content:'Test')}.to change{Whitecard.count}.by(1)
  end

  it 'should not add a white card to the database without a content' do
    expect{Whitecard.create()}.to_not change{Whitecard.count}
  end

end
