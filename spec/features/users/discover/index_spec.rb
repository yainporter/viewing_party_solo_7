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
end
