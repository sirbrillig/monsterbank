require 'spec_helper'

describe "Monster list" do

  before :each do
    @user = FactoryGirl.create(:user)
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')
    Monster.destroy_all
    FactoryGirl.create(:level1_artillery, :name => 'testmonster', :user => @user)
    FactoryGirl.create(:level1_artillery, :role => 'Soldier', :name => 'a monster', :user => @user)
  end

  it "displays Monster attribute headers" do
    visit monsters_path
    page.should have_content "Listing monsters"
    page.should have_content "Name"
    page.should have_content "Level"
    page.should have_content "Role"
    page.should have_content "Subrole"
  end

  it "displays a list of Monsters" do
    visit monsters_path
    page.should have_content "testmonster"
    page.should have_content "Artillery"
    page.should have_content "a monster"
    page.should have_content "Soldier"
  end
end

