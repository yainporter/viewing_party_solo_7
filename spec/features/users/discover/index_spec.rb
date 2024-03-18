require 'rails_helper'

RSpec.describe 'Discover Page', type: :feature do
  before do
    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    visit user_discover_index_path
  end
  describe "User Story 1 - Discover Movies: Search by Title" do
    it "has default features" do
      expect(page).to have_css(:button, "Discover Top Rated Movies")
      expect(page).to have_css(:text_field)
      expect(page).to have_css(:button, "Search by Movie Title")
    end
  end
end
