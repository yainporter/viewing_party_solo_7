require "rails_helper"

RSpec.describe Movie do
  it "is a Movie" do
    data = {
      movie_info: {
        id: 10,
        title: "Happy",
        vote_average: 8.7
      }
    }
    movie = Movie.new(data)
    expect(movie).to be_a(Movie)
    expect(movie.id).to be_an(Integer)
    expect(movie.id).to eq(10)
    expect(movie.title).to eq("Happy")
    expect(movie.title).to be_a(String)
    expect(movie.vote_average).to eq(8.7)
    expect(movie.vote_average).to be_a(Float)
  end

  it "has attributes from Facade's #movie_data", :vcr do
    facade = MovieFacade.new(240)
    movie = Movie.new(facade.full_movie_data)

    expect(movie.cast).to be_an Array
    expect(movie.genres).to be_an Array
    expect(movie.reviews).to be_an Array
    expect(movie.id).to be_an Integer
    expect(movie.runtime).to be_an Integer
    expect(movie.vote_average).to be_a Float
    expect(movie.summary).to be_a String
    expect(movie.title).to be_a String
  end

  it "has attributes from Facade's similar movies", :vcr do
    facade = MovieFacade.new(240)
    similar_movies = facade.similar_movies

    similar_movies.each do |movie|
      expect(movie).to be_a(Movie)
      expect(movie.id.present?).to be(true)
      expect(movie.title.present?).to be(true)
      expect(movie.summary.present?).to be(true)
      expect(movie.release_date.present?).to be(true)
      expect(movie.poster_path.present?).to be(true)
      expect(movie.vote_average.present?).to be(true)
    end
  end

  describe "instance methods" do
    describe "#convert_runtime" do
      it "converts the minutes into an hr..min format" do
        data = {
          movie_info: {
            runtime: 100
          }
        }

        movie = Movie.new(data)

        expect(movie.convert_runtime).to eq("1hr 40min")

        data_2 = {
          movie_info: {
            runtime: 20
          }
        }

        movie_2 = Movie.new(data_2)

        expect(movie_2.convert_runtime).to eq("0hr 20min")
      end
    end

    describe "#genres_to_string" do
      it "converts the @genres Array to a String" do
        data = {
          movie_info: {
            genres: [{id: 1, name: "Action"}, {id: 2, name: "Romance"}]
          }
        }
        movie = Movie.new(data)
        expect(movie.genres_to_string).to eq("Action, Romance")
      end
    end

    describe "#num_of_reviews" do
      it "returns 0 when there are no movie_reviews" do
        data = {
          movie_info: {
            genres: [{id: 1, genre: "Action"}, {id: 2, genre: "Romance"}]
          }
        }
        movie = Movie.new(data)

        expect(movie.num_of_reviews).to eq(0)
      end

      it "counts the number of movie_reviews" do
        data_2 = {
          movie_info: {},
          movie_reviews: [{id: 1, genre: "Action"}, {id: 2, genre: "Romance"}]
        }
        movie_2 = Movie.new(data_2)

        expect(movie_2.num_of_reviews).to eq(2)
      end
    end
  end
end
