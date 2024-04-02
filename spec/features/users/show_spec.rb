require "rails_helper"

RSpec.describe "User Dashboard" do
  before do
    movie_data = {
      movie_info: {
        id: 240
      }
    }

    3.times do
      User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")
    end
    @movie = Movie.new(movie_data)
    @user = User.create!(id: 1, name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")
    @viewing_party1 = ViewingParty.create!(id: 1, duration: rand(0..240), date: "2024-03-30", start_time: "20:35", movie_id: @movie.id)
    @viewing_party2 = ViewingParty.create!(id: 2, duration: rand(0..240), date: "2024-03-22", start_time: "14:15", movie_id: @movie.id)
    UserParty.create!(viewing_party: @viewing_party1, user: User.fourth, host: true)
    UserParty.create!(viewing_party: @viewing_party1, user: User.second, host: false)
    UserParty.create!(viewing_party: @viewing_party1, user: User.third, host: false)
    UserParty.create!(viewing_party: @viewing_party1, user: @user, host: true)

    UserParty.create!(viewing_party: @viewing_party2, user: User.second, host: true)
    UserParty.create!(viewing_party: @viewing_party2, user: User.fourth, host: false)
    UserParty.create!(viewing_party: @viewing_party2, user: @user, host: false)

    @facade = MovieFacade.new(@movie.id)

    visit user_path(@user)
  end

  describe "User Story 7 - Add Movie Info" do
    it "displays movie details for Viewing Parties a User has been invited to", :vcr do
      within ".movie-#{@movie.id}-party-#{@viewing_party2.id}" do
        expect(page).to have_css("img[src]")
        expect(page).to have_link("The Godfather Part II")
        expect(page).to have_content("Party Time: 14:15")
        expect(page).to have_content("Party Date: 2024-03-22")
        expect(page).to have_content("Host: #{User.second.name}")
        expect(page).to have_css("li", text: "#{User.second.name}")
        expect(page).to have_css("li", text: "#{User.first.name}")
        expect(page).to have_css("li", text: "#{@user.name}") # This needs to be boleded
        expect(page).to have_css("strong", text: "#{@user.name}") # This needs to be boleded
        expect(page).to have_css("li", count: 3)
      end
    end

    it "displays movie details for Viewing Parties a User is hosting", :vcr do
      within ".movie-#{@movie.id}-party-#{@viewing_party1.id}" do
        expect(page).to have_css("img[src]")
        expect(page).to have_link("The Godfather Part II")
        expect(page).to have_content("Party Time: 20:35")
        expect(page).to have_content("Party Date: 2024-03-30")
        expect(page).to have_content("Host: #{@user.name}")
        expect(page).to have_css("li", text: "#{User.second.name}")
        expect(page).to have_css("li", text: "#{User.first.name}")
        expect(page).to have_css("li", text: "#{User.third.name}")
        expect(page).to have_css("li", text: "#{@user.name}")
        expect(page).to have_css("li", count: 4)
      end
    end
  end

  # describe "Log out" do
  #   it "has a link to log out redirects to the login page when clicked", :vcr do
  #     expect(page).to have_link("Log Out")

  #     click_link("Log Out")

  #     expect(page.current_path).to eq(login_path)
  #   end
  # end
end
