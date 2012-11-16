require 'spec_helper'

describe "Tag list" do
  before do
    @user = FactoryGirl.create(:user, :email => 'taglisttest1@test.com')
    @user2 = FactoryGirl.create(:user, :email=> 'taglisttest2@test.com')
    @tag = FactoryGirl.create(:tag, :name => 'taglisttesttag', :user => @user)
    visit login_path
    fill_in('email', :with => @user.email) 
    fill_in('password', :with => @user.password)
    click_button('Log In')
    Monster.destroy_all
    @mon1 = FactoryGirl.create(:monster, :name => 'tagtestmonster1', :user => @user)
    @mon2 = FactoryGirl.create(:monster, :role => 'Soldier', :name => 'tagtestmonster2', :user => @user)
    @mon3 = FactoryGirl.create(:monster, :role => 'Soldier', :name => 'tagtestmonster3', :user => @user2)
    @mon4 = FactoryGirl.create(:monster, :role => 'Controller', :name => 'tagtestmonster4', :user => @user)
    @tag.monsters << @mon1 << @mon3 << @mon4
    visit tag_path(@tag)
  end

  it "displays the name of the tag" do
    page.should have_content @tag.name
  end

  it "lists all the monsters with that tag" do
    page.should have_content @mon1.name
    page.should have_content @mon4.name
  end

  it "does not list a monster without that tag" do
    page.should_not have_content @mon2.name
  end

  it "does not list a monster with that tag belonging to another user" do
    page.should_not have_content @mon3.name
  end

  it "shows a link to the full monster list" do
    page.should have_link_to monsters_path
  end
end
