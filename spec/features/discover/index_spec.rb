require 'rails_helper'

RSpec.describe 'Discover Page', type: :feature do
  before do
    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    visit user_discover_index_path(@user)
  end

  describe "User Story 1 - Discover Movies: Search by Title" do
    it "has default page items" do
      expect(page).to have_content("Viewing Party")
      expect(page).to have_content("Discover Movies")
    end

    it "has a working form to search for movies" do
      expect(page).to have_field(:keyword)
      expect(page).to have_button("Find Movies")
    end

    it "has a button to the movies results page" do
      expect(page).to have_button("Find Top Rated Movies")
    end
  end

  describe "User Story 2 - Movie Results Page" do
    it "has working links for the buttons" do
      json_response = File.read("spec/fixtures/top_rated_movies.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      click_button("Find Top Rated Movies")
      expect(page.current_path).to eq(user_movies_path(@user))

      json_response = File.read("spec/fixtures/movie_search_bad_1.json")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Bad&include_adult=false&language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      visit user_discover_index_path(@user)
      fill_in(:keyword, with: "Bad")
      click_button("Find Movies")
      expect(page.current_path).to eq(user_movies_path(@user))
    end
  end
end
