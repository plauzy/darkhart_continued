require 'rails_helper'

RSpec.describe BlackCard, :type => :model do
  before :each do
    BlackCard.destroy_all
  end

  it 'Creating a new BlackCard adds a BlackCard object' do
    expect{BlackCard.new}.to change(BlackCard.count).by(1)
  end

end
