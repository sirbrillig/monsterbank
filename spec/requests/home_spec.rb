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
    page.should have_link('', {src: new_monster_path})
  end

  it "displays the 'Log In' link" do
    page.should have_link('', {src: login_path})
  end
end
