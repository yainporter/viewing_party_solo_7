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
      visit user_movies_path(@user, keyword: "top 20rated")

      expect(find('#top-20-movies')).to have_selector('tr', count: 20)
      json_response = File.read("spec/fixtures/movie_search_bad_1.json")
      expect(page).to have_no_css("table#search-params")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Bad&include_adult=false&language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      visit user_movies_path(@user, keyword: "Bad")
      expect(find('#search-params')).to have_selector('tr', count: 20)
      expect(page).to have_no_css("table#top-20-movies")
    end

    it "displays the filter results as a link" do
      visit user_movies_path(@user, keyword: "top 20rated")

      movie_names = ["The Shawshank Redemption",
                     "The Godfather",
                     "The Godfather Part II",
                     "Schindler's List",
                     "12 Angry Men",
                     "Spirited Away",
                     "Dilwale Dulhania Le Jayenge",
                     "The Dark Knight",
                     "Parasite",
                     "The Green Mile",
                     "Your Name.",
                     "Pulp Fiction",
                     "The Lord of the Rings: The Return of the King",
                     "Forrest Gump",
                     "GoodFellas",
                     "The Good, the Bad and the Ugly",
                     "Grave of the Fireflies",
                     "Cinema Paradiso",
                     "Life Is Beautiful",
                     "Seven Samurai"]

      within "#top-20-movies" do
        movie_names.each do |movie_name|
          expect(page).to have_link(movie_name)
          expect(page).to have_content("Vote Average: ")
        end
      end

      json_response = File.read("spec/fixtures/movie_search_bad_1.json")
      expect(page).to have_no_css("table#search-params")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Bad&include_adult=false&language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      visit user_movies_path(@user, keyword: "Bad")

      movie_names = ["Bad",
                     "Badland Hunters",
                     "Land of Bad",
                     "Bad Lands",
                     "Bad",
                     "BAD",
                     "bad",
                     "Bad",
                     "The Good, the Bad and the Ugly",
                     "Bad Company",
                     "Serial (Bad) Weddings",
                     "The Bad Guys: The Movie",
                     "Serial (Bad) Weddings 3",
                     "Serial (Bad) Weddings 2",
                     "Bad Boys for Life",
                     "Badrinath Ki Dulhania",
                     "Trigun: Badlands Rumble",
                     "Bad Milo!",
                     "Bad City",
                     "Bad Boy in Love"]

      within "#search-params" do
        movie_names.each do |movie_name|
          expect(page).to have_link(movie_name)
          expect(page).to have_content("Vote Average: ")
        end
      end
    end

    it "takes you to the show page when you click on a link with a movie name", :vcr do
      visit user_movies_path(@user, keyword: "top 20rated")

      click_link("The Godfather")
      expect(page.current_path).to eq("/users/#{@user.id}/movies/238")
    end
  end
end
