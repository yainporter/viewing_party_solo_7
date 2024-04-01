require "rails_helper"

RSpec.describe "Registration", type: :feature do
  before(:each) do
    visit "/register"
  end

  describe "User Story 1 - Registration(w/ Authentication)" do
    it "authenticates a User successfully" do
      expect(page).to have_css("#registration_form")

      within "#registration_form" do
        expect(page).to have_field("Name")
        expect(page).to have_field("Email")
        expect(page).to have_field("Password")
        expect(page).to have_field("Confirm Password")
        expect(page).to have_button("Register")

        fill_in("user[name]", with: "User")
        fill_in("user[email]", with: "User@test.com")
        fill_in("user[password]", with: "testing")
        fill_in("user[password_confirmation]", with: "testing")
        click_button("Register")
      end
      user = User.last

      expect(page.current_path).to eq(user_path(user))
    end
  end
end
