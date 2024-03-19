require "rails_helper"

RSpec.describe Movie do
  it "is a Movie" do
    data = {
      title: "Happy",
      vote_average: 8.7
    }
    movie = Movie.new(title: "Happy", vote_average: 8.7)
    expect(movie).to be_a(Movie)
    expect(movie.title).to eq("Happy")
    expect(movie.title).to be_a(String)
    expect(movie.vote_average).to eq(8.7)
    expect(movie.vote_average).to be_a(Float)
  end

  it "has extra attributes" do
    data = {
      title: "Happy",
      vote_average: 8.7
    }
  end

  it "has attributes from Facade's #movie_info" do
    data = {
      id: 2,
      title: "Happy",
      vote_average: 8.7,
      genres: [id: 1, genre: "crime"],
      summary: "Good movie",
      runtime: 90,
      reviews: [{:author=>"jkbbr549",
        :author_details=>{:name=>"", :username=>"jkbbr549", :avatar_path=>nil, :rating=>nil},
        :content=>"This is by far the greatest movie of all time!  Even better than the first Godfather!",
        :created_at=>"2015-04-21T11:41:26.541Z",
        :id=>"553637669251416518002602",
        :updated_at=>"2021-06-23T15:57:34.131Z",
        :url=>"https://www.themoviedb.org/review/553637669251416518002602"},
       {:author=>"Matthew Dixon",
        :author_details=>{:name=>"Matthew Dixon", :username=>"matthewdixon", :avatar_path=>"/Af7sJr2dLx38npWMIaDzVmdzwd4.jpg", :rating=>10.0},
        :content=>
         "Worthy sequel to the first movie. In something more meditative and unhurried, in something more philosophically meaningful than its legendary predecessor. Backstage games and backstage talks replaced the dramatic mood swings of the main characters and the exchange of fire.\r\n\r\nThe second film continues the story of Michael Carleone in the role of the Godfather, and also complements the family story with scenes of the formation of the young Vito Andolini and his escape to America. The difficult choice of being young Don, his sphere of expansion of influence opens up new heights and horizons, but also acquires new enemies. Big money and power always keep pace with great temptation, and therefore you should always keep your ears open. After all, the knife in the back can insert exactly the one from whom you do not expect ...",
        :created_at=>"2019-07-30T08:28:10.884Z",
        :id=>"5d3fff9ab87aec6aa339e228",
        :updated_at=>"2021-06-23T15:58:24.936Z",
        :url=>"https://www.themoviedb.org/review/5d3fff9ab87aec6aa339e228"}],
      cast: [{name: "John"}]
    }

    movie = Movie.new(data)
    expect(movie.cast).to be_an Array
    expect(movie.genres).to be_an Array
    expect(movie.reviews).to be_an Array
    expect(movie.id).to be_an Integer
    expect(movie.runtime).to be_an Integer
    expect(movie.vote_average).to be_a Float
    expect(movie.summary).to be_a String
    expect(movie.title).to be_a String
  end

  describe "instance methods" do
    describe "#convert_runtime" do
      it "converts the minutes into an hr..min format" do
        data = {
          runtime: 100
        }

        movie = Movie.new(data)

        expect(movie.convert_runtime).to eq("1hr 40min")

        data_2 = {
          runtime: 20
        }

        movie_2 = Movie.new(data_2)

        expect(movie_2.convert_runtime).to eq("0hr 20min")
      end
    end

    describe "#genres_to_string" do
      it "converts the @genres Array to a String" do
        data = {
          genres: [{id: 1, name: "Action"}, {id: 2, name: "Romance"}]
        }
        movie = Movie.new(data)
        expect(movie.genres_to_string).to eq("Action, Romance")
      end
    end

    describe "#num_of_reviews" do
      it "counts the size of the number of @reviews" do
        data = {
          genres: [{id: 1, genre: "Action"}, {id: 2, genre: "Romance"}]
        }
        movie = Movie.new(data)

        expect(movie.num_of_reviews).to eq(0)

        data_2 = {
          reviews: [{id: 1, genre: "Action"}, {id: 2, genre: "Romance"}]
        }
        movie_2 = Movie.new(data_2)

        expect(movie_2.num_of_reviews).to eq(2)
      end
    end
  end
end
