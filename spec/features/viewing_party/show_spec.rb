require "rails_helper"

RSpec.desribe "Viewing Party Show Page" do
  before do
    movie_data = {
      movie_info: {
        id: 240
      }
    }

    @movie = Movie.new(movie_data)
    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    10.times do
      User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    end
    ViewingParty.create!(duration: rand(0..240), date: Faker::Date.forward(days: rand(1..14)), start_time: Time.new.strftime("%H:%M"))
    UserParty.create!(viewing_party: ViewingParty.first, user: User.first, host: true)
    UserParty.create!(viewing_party: ViewingParty.first, user: User.second, host: false)
    UserParty.create!(viewing_party: ViewingParty.first, user: User.third, host: false)
    UserParty.create!(viewing_party: ViewingParty.last, user: User.second, host: false)
    UserParty.create!(viewing_party: ViewingParty.last, user: User.first, host: false)

    visit user_movie_viewing_party_path(@user, @movie, ViewingParty.first)
  end

  describe "User Story 5 - Where to Watch" do
    it "displays logos of where to buy and rent", :vcr do
      expect(page.find(".buy")["src"]).should have_content("")
    end
  end
end
