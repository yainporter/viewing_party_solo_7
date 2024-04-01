require "rails_helper"

RSpec.describe "Registration", type: :feature do
  before(:each) do
    visit "/register"
  end

  describe "User Story 1 - Registration(w/ Authentication) Happy Path" do
    it "authenticates a User successfully" do
      expect(page).to have_css(:registration_form)

      within "#registration_form" do
        expect(page).to have_css(:name)
        expect(page).to have_css(:email)
        expect(page).to have_css(:password)
        expect(page).to have_css(:password_confirmation)
        expect(page).to have_button("Register")

        fill_in(:name, with: "User")
        fill_in(:email, with: "User@test.com")
        fill_in(:password, with: "testing")
        fill_in(:password_confirmation, with: "testing")
        click_button("Register")
      end

      expect(page.current_path).to eq("/users/:id")
    end
  end
end
