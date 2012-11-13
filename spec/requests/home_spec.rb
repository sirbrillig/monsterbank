require 'spec_helper'

describe "Home page" do
  before do
    visit root_url
  end

  it "displays the service summary headers" do
    page.should have_content "Making Monsters Easy"
    page.should have_content "Here When You Want"
    page.should have_content "You Do the Cool Stuff"
    page.should have_content "Paper is Cool Too"
  end

  it "displays the 'Make a Monster' button" do
    page.should have_link_to new_monster_path
  end

  context "when not logged-in" do
    it "displays the 'Log In' link" do
      page.should have_link_to login_path
    end
  end

  context "when logged-in" do
    before :each do
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in('email', :with => @user.email) 
      fill_in('password', :with => @user.password)
      click_button('Log In')
      visit root_url
    end

    it "displays the 'My Monsters' link" do
      page.should have_link_to monsters_path
    end

    it "displays a logout link" do
      page.should have_link_to logout_path
    end
  end
end
