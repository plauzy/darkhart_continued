require 'rails_helper'

RSpec.describe Round, :type => :model do
  before :each do
    Round.destroy_all
  end

  it 'Creating a new Round adds a Round object' do
    expect{Round.new}.to change(Round.count).by(1)
  end

end
