require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  before do
    # json_response = File.read("spec/fixtures/movie_show_porter.json")

    # stub_request(:get, "https://api.themoviedb.org/3/movie/1090265?language=en-US").
    #   with(
    #     headers: {
    #       "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
    #     }
    #   ).to_return(status: 200, body: json_response)

    movie_data = {
        id: 1090265,
        title: "Porter",
        vote_average: 8.7
      }
    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    @movie = Movie.new(movie_data)
    visit user_movie_path(@user, @movie.id)
  end

  it "displays default buttons", :vcr do
      visit user_movie_path(@user, @movie.id)

      expect(page).to have_button("Discover Page")
      expect(page).to have_button("Create Viewing Party for Porter")
  end

  it "displays information about the Movie", :vcr do
    visit user_movie_path(@user, @movie.id)
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
    visit user_movie_path(@user, 240)

    click_button("Create Viewing Party for The Godfather Part II Page")
    expect(page.current_path).to eq(new_user_movie_viewing_party_path(@user.id, 240))
  end
end
