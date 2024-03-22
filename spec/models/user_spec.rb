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

  describe "#movie_ids" do
    it "returns a unique list of movie_ids for a User's viewing parties" do
      movie_data1 = {
        movie_info: {
          id: 240
        }
      }

      movie_data2 = {
        movie_info: {
          id: 300
        }
      }

      movie_data3 = {
        movie_info: {
          id: 300
        }
      }

      movie1 = Movie.new(movie_data1)
      movie2 = Movie.new(movie_data2)
      movie3 = Movie.new(movie_data3)
      user1 = User.create!(id: 1, name: Faker::Name.name, email: Faker::Internet.email)
      user2 = User.create!(id: 2, name: Faker::Name.name, email: Faker::Internet.email)
      viewing_party1 = ViewingParty.create!(id: 1, duration: rand(0..240), date: "2024-03-30", start_time: "20:35", movie_id: movie1.id)
      viewing_party2 = ViewingParty.create!(id: 2, duration: rand(0..240), date: "2024-03-22", start_time: "14:15", movie_id: movie2.id)
      viewing_party3= ViewingParty.create!(id: 3, duration: rand(0..240), date: "2024-03-22", start_time: "14:15", movie_id: movie3.id)
      UserParty.create!(viewing_party: viewing_party1, user: user1, host: true)
      UserParty.create!(viewing_party: viewing_party2, user: user1, host: false)
      UserParty.create!(viewing_party: viewing_party3, user: user1, host: false)


      expect(user1.movie_ids).to be_an(Array)
      expect(user1.movie_ids).to eq([240, 300])
      expect(user2.movie_ids).to eq([])
    end
  end
end
