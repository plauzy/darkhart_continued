require 'rails_helper'

RSpec.describe Blackcard, :type => :model do
  before :each do
    Blackcard.destroy_all
  end

  it 'Creating a new BlackCard adds a BlackCard object' do
    expect{Blackcard.create(content:'Test')}.to change{Blackcard.count}.by(1)
  end

end
