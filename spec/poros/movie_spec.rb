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
end
