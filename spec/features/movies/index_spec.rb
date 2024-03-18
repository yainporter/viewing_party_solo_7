require 'rails_helper'

RSpec.describe 'Movies Page', type: :feature do
  before do
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
      visit user_movies_path(@user, q: "top 20rated")
      expect(find('ul.text')).to have_selector('li', count: 20)
    end
  end
end
