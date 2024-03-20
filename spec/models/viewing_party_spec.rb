require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  before(:each) do
      @user_1 = User.create!(name: 'Sam', email: 'sam@email.com')
      @user_2 = User.create!(name: 'Tommy', email: 'tommy@email.com')
      @party = ViewingParty.create!(date: "2023-12-01", start_time: "07:25", duration: 175)
      UserParty.create!(user_id: @user_1.id, viewing_party_id: @party.id, host: true)
      UserParty.create!(user_id: @user_2.id, viewing_party_id: @party.id, host: false)
  end

  describe 'relationships' do
      it { should have_many :user_parties }
      it { should have_many(:users).through(:user_parties) }
  end

  describe "instance methods" do
    it "returns user that is hosting the party" do
      expect(@party.find_host).to eq (@user_1)
    end
  end
end
