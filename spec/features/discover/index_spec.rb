require 'rails_helper'

RSpec.describe 'Discover Page', type: :feature do
  before do
    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit discover_index_path
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
    it "has working links for the buttons", :vcr do
      visit discover_index_path(@user)
      fill_in(:keyword, with: "Bad")
      click_button("Find Movies")
      expect(page.current_path).to eq(movies_path)
    end
  end
end
