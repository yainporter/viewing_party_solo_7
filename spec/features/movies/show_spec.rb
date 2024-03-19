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
    facade = MovieFacade.new
    @movie = facade.make_movies(facade.top_movies).first

    visit user_movie_path(@user, @movie)
  end

  it "displays default buttons" do
    expect(page).to have_button("Discover Page")
    expect(page).to have_button("Create Viewing Party for The Shawshank Redemption")
  end

  it "displays information about the Movie" do
    expect(page).to have_selector("h2", text: "The Shawshank Redemption")
    expect(page).to have_content("Vote: 8.7")
    expect(page).to have_content("Runtime: ")
    expect(page).to have_content("Genre: ")
  end
end
