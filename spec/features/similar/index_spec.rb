require "rails_helper"

RSpec.describe "Similar Movies Page" do
  before do
    movie_data = {
      movie_info: {
        id: 240
      }
    }

    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")
    @movie = Movie.new(movie_data)
    visit similar_movies_path(@user, @movie.id)
  end

  describe "User Story 6 - Similar Movies" do
    it "displays similar movies", :vcr do
      facade = MovieFacade.new(@movie.id)
      similar_movies = facade.similar_movies
      similar_movies.each do |movie|
        within "#similar-movies" do
          expect(page).to have_css("#similar-movie-#{movie.id}")
          within "#img-#{movie.id}" do
            expect(page).to have_css("img[src]")
          end

          within "#similar-movie-#{movie.id}" do
            expect(page).to have_text("Title:")
            expect(page).to have_text("Overview:")
            expect(page).to have_text("Release Date:")
            expect(page).to have_text("Vote Average:")
          end
        end
      end
    end
  end
end
