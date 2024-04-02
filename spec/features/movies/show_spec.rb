require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  before do
    movie_data = {
      movie_info: {
        id: 1090265,
        title: "Porter",
        vote_average: 8.7
      }
    }
    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")
    @movie = Movie.new(movie_data)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/movies/#{@movie.id}"
  end

  it "displays default buttons", :vcr do
      expect(page).to have_button("Discover Page")
      expect(page).to have_button("Create Viewing Party for Porter")
  end

  it "displays information about the Movie", :vcr do
    expect(page).to have_selector("h2", text: "Porter")
    within "#movie_info" do
      expect(page).to have_content("Vote: 0")
      expect(page).to have_content("Runtime: 1hr 22min")
      expect(page).to have_content("Genre: Crime")
    end
    expect(page).to have_selector("h3", text: "Summary")
    expect(page).to have_selector("h3", text: "Cast")
    expect(find('#cast')).to have_selector('tr', count: 11)
    expect(page).to have_selector("h3", text: "0 Reviews")
  end

  it "has a working create viewing party button", :vcr do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit "/movies/240"

    click_button("Create Viewing Party for The Godfather Part II Page")
    expect(page.current_path).to eq(new_movie_viewing_party_path(240))
  end

  describe "User Story 6 - Similar Movies" do
    it "has a link to display similar movies", :vcr do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      expect(page).to have_button("Get Similar Movies")
      click_button("Get Similar Movies")

      expect(page.current_path).to eq(similar_movies_path(@movie.id))
      expect(page).to have_css("#similar-movies")
    end
  end

  describe "Part 7 - Create a Viewing Party Authorization" do
    it "can not be created if a User is not logged in", :vcr do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)

      click_button("Create Viewing Party")

      expect(page.current_path).to eq(movie_path(@movie.id))
      expect(page).to have_content("Must be logged in or registered to create a Viewing Party")
    end
  end
end
