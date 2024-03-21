require "rails_helper"

RSpec.describe "Viewing Party Show Page" do
  before do
    movie_data = {
      movie_info: {
        id: 240
      }
    }

    @movie = Movie.new(movie_data)
    @user = User.create!(id: 1, name: Faker::Name.name, email: Faker::Internet.email)
    3.times do
      User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    end
    viewing_party = ViewingParty.create!(id: 1, duration: rand(0..240), date: Faker::Date.forward(days: rand(1..14)), start_time: Time.new.strftime("%H:%M"))
    UserParty.create!(viewing_party: viewing_party, user: User.first, host: true)
    UserParty.create!(viewing_party: viewing_party, user: User.second, host: false)
    UserParty.create!(viewing_party: viewing_party, user: User.third, host: false)
    UserParty.create!(viewing_party: ViewingParty.last, user: User.second, host: false)
    UserParty.create!(viewing_party: ViewingParty.last, user: User.first, host: false)
    @facade = MovieFacade.new(@movie.id)
    visit user_movie_viewing_party_path(@user, @movie.id, viewing_party.id)
  end

  describe "User Story 5 - Where to Watch" do
    it "displays logos of where to stream", :vcr do
      save_and_open_page
      stream_ids = []
      @facade.watch_providers("flatrate").each do |provider|
        stream_ids << provider[:provider_id]
      end

      stream_ids.each do |id|
        src = "img[src]#stream-#{id}"
        xpath = page.find(src).path
        expect(page).to have_css(src)
        expect(page).to have_xpath(xpath)
      end
    end

    it "displays logos of where to rent", :vcr do
      rent_ids = []
      @facade.watch_providers("rent").each do |provider|
        rent_ids << provider[:provider_id]
      end

      rent_ids.each do |id|
        src = "img[src]#rent-#{id}"
        xpath = page.find(src).path
        expect(page).to have_css(src)
        expect(page).to have_xpath(xpath)
      end
    end

    it "displays logos of where to buy", :vcr do
      buy_ids = []
      @facade.watch_providers("rent").each do |provider|
        buy_ids << provider[:provider_id]
      end

      buy_ids.each do |id|
        src = "img[src]#buy-#{id}"
        xpath = page.find(src).path
        expect(page).to have_css(src)
        expect(page).to have_xpath(xpath)
      end
    end

    it "has a data attribution for the JustWatch platform", :vcr do
      expect(page).to have_content("Buy/Rent data provided by JustWatch")
    end
  end
end
