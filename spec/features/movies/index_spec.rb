require 'rails_helper'

RSpec.describe 'Movies Page', type: :feature do
  before do
    json_response = File.read("spec/fixtures/top_rated_movies.json")

    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
      with(
        headers: {
          "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
        }
      ).to_return(status: 200, body: json_response)

    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    visit user_movies_path(@user)
  end

  describe "User Story 2 - Movie Results" do
    it "has default features" do
      expect(page).to have_content("Viewing Party")
      expect(page).to have_button("Discover Page")
      click_button("Discover Page")
      expect(page.current_path).to eq(user_discover_index_path(@user))
    end

    it "filters page results" do
      visit user_movies_path(@user, q: "top 20rated")

      expect(find('#top-20-movies')).to have_selector('tr', count: 20)
      json_response = File.read("spec/fixtures/movie_search_bad_1.json")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Bad&include_adult=false&language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      visit user_movies_path(@user, keyword: "Bad")
    end
  end
end
