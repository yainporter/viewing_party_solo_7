require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should allow_value('something@something.something').for(:email) }
    it { should_not allow_value('something somthing@something.something').for(:email) }
    it { should_not allow_value('something.something@').for(:email) }
    it { should_not allow_value('something').for(:email) }

  end

  describe 'associations' do
    it { should have_many :user_parties }
    it { should have_many(:viewing_parties).through(:user_parties) }
  end

  describe "class methods" do
    describe ".all_but" do
      it "returns all users but the one with the ID passed through" do
        10.times do
          User.create!(name: Faker::Name.name, email: Faker::Internet.email)
        end

        user_1 = User.create!(name: "Jan", email: "tester@test.com")
        users = User.all_but(user_1.id)

        users.each do |user|
          expect(user.id).not_to eq(user_1.id)
        end
      end
    end
  end

  # describe "instance methods" do
  #   describe "#host?" do
  #     it "returns true if a User is a host" do
  #       user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
  #       user2 = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
  #       user3 = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
  #       viewing_party1 = ViewingParty.create!(id: 1, duration: rand(0..240), date: "2024-03-30", start_time: "20:35")
  #       viewing_party2 = ViewingParty.create!(id: 2, duration: rand(0..240), date: "2024-03-22", start_time: "14:15")
  #       viewing_party3 = ViewingParty.create!(id: 3, duration: rand(0..240), date: "2024-03-22", start_time: "14:15")
  #       party1 = UserParty.create!(viewing_party: viewing_party1, user: user, host: true)
  #       party2 = UserParty.create!(viewing_party: viewing_party1, user: user2, host: false)
  #       party3 = UserParty.create!(viewing_party: viewing_party1, user: user3, host: false)

  #       party4 = UserParty.create!(viewing_party: viewing_party2, user: user, host: true)
  #       party5 = UserParty.create!(viewing_party: viewing_party2, user: user2, host: false)
  #       party6 = UserParty.create!(viewing_party: viewing_party2, user: user3, host: false)

  #       party7 = UserParty.create!(viewing_party: viewing_party3, user: user, host: false)
  #       party8 = UserParty.create!(viewing_party: viewing_party3, user: user2, host: false)
  #       party9 = UserParty.create!(viewing_party: viewing_party3, user: user3, host: true)

  #       user.viewing_parties.each do |party|
  #         require 'pry'; binding.pry
  #         party.users.each do |attendee|
  #           if attendee.id == user.id && (party.id == party1.id || party4.movie_id)
  #             expect(user.host?).to eq(true)
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
end
